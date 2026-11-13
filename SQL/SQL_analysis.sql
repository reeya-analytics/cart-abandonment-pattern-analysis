-- 1. Total session records and unique sessions
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT website_session_id) AS unique_sessions
FROM cart_abandonment_analysis.website_sessions;

-- 2. Total pageviews and unique sessions with pageviews
SELECT
    COUNT(*) AS total_pageviews,
    COUNT(DISTINCT website_session_id) AS unique_sessions
FROM cart_abandonment_analysis.website_pageviews;

-- 3. Average pageviews per unique session
SELECT
    ROUND(
        COUNT(*) /
        COUNT(DISTINCT website_session_id), 2
    ) AS avg_pageviews_per_session
FROM cart_abandonment_analysis.website_pageviews;

-- 4. Check duplicate session IDs
SELECT
    website_session_id,
    COUNT(*) AS record_count
FROM cart_abandonment_analysis.website_sessions
GROUP BY website_session_id
HAVING COUNT(*) > 1;

-- 5. Check duplicate pageview IDs
SELECT
    website_pageview_id,
    COUNT(*) AS record_count
FROM cart_abandonment_analysis.website_pageviews
GROUP BY website_pageview_id
HAVING COUNT(*) > 1;

-- 6. Check missing session IDs in website_sessions
SELECT
    COUNT(*) AS missing_session_ids
FROM cart_abandonment_analysis.website_sessions
WHERE website_session_id IS NULL;

-- 7. Check missing pageview IDs and session IDs
SELECT
    SUM(CASE WHEN website_pageview_id IS NULL THEN 1 ELSE 0 END) AS missing_pageview_ids,
    SUM(CASE WHEN website_session_id IS NULL THEN 1 ELSE 0 END) AS missing_session_ids
FROM cart_abandonment_analysis.website_pageviews;

-- 8. Check how many pageviews each session generated
SELECT
    website_session_id,
    COUNT(*) AS pageview_count
FROM cart_abandonment_analysis.website_pageviews
GROUP BY website_session_id
HAVING COUNT(*) > 1
ORDER BY pageview_count DESC;

-- 9. Compare total pageview records with unique sessions
SELECT
    COUNT(*) AS total_pageviews,
    COUNT(DISTINCT website_session_id) AS unique_sessions,
    COUNT(*) - COUNT(DISTINCT website_session_id) AS additional_pageview_records
FROM cart_abandonment_analysis.website_pageviews;

-- 10. Check session ID relationships between sessions and pageviews
SELECT
    COUNT(*) AS unmatched_pageview_sessions
FROM (
    SELECT DISTINCT wp.website_session_id
    FROM cart_abandonment_analysis.website_pageviews AS wp
    LEFT JOIN cart_abandonment_analysis.website_sessions AS ws
        ON wp.website_session_id = ws.website_session_id
    WHERE ws.website_session_id IS NULL
) AS unmatched;

-- 11. Check date range of unmatched pageview sessions
SELECT
    MIN(wp.created_at) AS first_unmatched_session,
    MAX(wp.created_at) AS last_unmatched_session,
    COUNT(DISTINCT wp.website_session_id) AS unmatched_sessions

FROM cart_abandonment_analysis.website_pageviews AS wp

LEFT JOIN cart_abandonment_analysis.website_sessions AS ws
    ON wp.website_session_id = ws.website_session_id

WHERE ws.website_session_id IS NULL;

-- 12. Compare date ranges of both tables
SELECT
    'website_sessions' AS table_name,
    MIN(created_at) AS first_record,
    MAX(created_at) AS last_record
FROM cart_abandonment_analysis.website_sessions

UNION ALL

SELECT
    'website_pageviews',
    MIN(created_at),
    MAX(created_at)
FROM cart_abandonment_analysis.website_pageviews;

-- 13. Count unique sessions visiting each website page
SELECT
    pageview_url,
    COUNT(DISTINCT website_session_id) AS unique_sessions
FROM cart_abandonment_analysis.website_pageviews
GROUP BY pageview_url
ORDER BY unique_sessions DESC;

-- 14. Calculate unique sessions progressing through the checkout funnel
WITH session_journey AS (
    SELECT
        website_session_id,

        MIN(IF(pageview_url = '/products', created_at, NULL)) AS products_time,
        MIN(IF(pageview_url = '/cart', created_at, NULL)) AS cart_time,
        MIN(IF(pageview_url = '/shipping', created_at, NULL)) AS shipping_time,
        MIN(IF(pageview_url = '/thank-you-for-your-order', created_at, NULL)) AS thankyou_time

    FROM `cart_abandonment_analysis.website_pageviews`
    GROUP BY website_session_id
)

SELECT
    COUNTIF(products_time IS NOT NULL) AS product_sessions,

    COUNTIF(
        products_time IS NOT NULL
        AND cart_time > products_time
    ) AS cart_sessions,

    COUNTIF(
        products_time IS NOT NULL
        AND cart_time > products_time
        AND shipping_time > cart_time
    ) AS shipping_sessions,

    COUNTIF(
        products_time IS NOT NULL
        AND cart_time > products_time
        AND shipping_time > cart_time
        AND thankyou_time > shipping_time
    ) AS completed_sessions

FROM session_journey;


-- 15. Calculate stage-to-stage conversion and drop-off rates

WITH funnel AS (
    SELECT 'Product' AS stage, 261231 AS sessions, 1 AS stage_order
    UNION ALL
    SELECT 'Cart', 94953, 2
    UNION ALL
    SELECT 'Shipping', 64484, 3
    UNION ALL
    SELECT 'Order Confirmation', 32313, 4
),

funnel_rates AS (
    SELECT
        stage,
        sessions,
        LAG(sessions) OVER (ORDER BY stage_order) AS previous_stage_sessions
    FROM funnel
)

SELECT
    stage,
    sessions,
    previous_stage_sessions,

    previous_stage_sessions - sessions AS sessions_lost,

    ROUND(
        SAFE_DIVIDE(sessions * 100.0, previous_stage_sessions), 2
    ) AS conversion_rate,

    ROUND(
        100.0 - SAFE_DIVIDE(sessions * 100.0, previous_stage_sessions), 2
    ) AS drop_off_rate

FROM funnel_rates
ORDER BY stage;


-- 16. Compare checkout funnel performance across devices

WITH session_journey AS (
    SELECT
        website_session_id,

        MIN(IF(pageview_url = '/products', created_at, NULL)) AS product_time,
        MIN(IF(pageview_url = '/cart', created_at, NULL)) AS cart_time,
        MIN(IF(pageview_url = '/shipping', created_at, NULL)) AS shipping_time,
        MIN(IF(pageview_url = '/thank-you-for-your-order', created_at, NULL)) AS confirmation_time

    FROM `cart_abandonment_analysis.website_pageviews`
    GROUP BY website_session_id
),

device_counts AS (
    SELECT
        COALESCE(ws.device_type, 'Unknown') AS device_type,

        COUNTIF(sj.product_time IS NOT NULL) AS product_sessions,

        COUNTIF(
            sj.product_time IS NOT NULL
            AND sj.cart_time > sj.product_time
        ) AS cart_sessions,

        COUNTIF(
            sj.product_time IS NOT NULL
            AND sj.cart_time > sj.product_time
            AND sj.shipping_time > sj.cart_time
        ) AS shipping_sessions,

        COUNTIF(
            sj.product_time IS NOT NULL
            AND sj.cart_time > sj.product_time
            AND sj.shipping_time > sj.cart_time
            AND sj.confirmation_time > sj.shipping_time
        ) AS confirmation_sessions

    FROM `cart_abandonment_analysis.website_sessions` AS ws
    INNER JOIN session_journey AS sj
        ON ws.website_session_id = sj.website_session_id

    GROUP BY device_type
),

device_funnel AS (
    SELECT device_type, 'Product' AS stage,
           product_sessions AS sessions, 1 AS stage_order
    FROM device_counts

    UNION ALL

    SELECT device_type, 'Cart', cart_sessions, 2
    FROM device_counts

    UNION ALL

    SELECT device_type, 'Shipping', shipping_sessions, 3
    FROM device_counts

    UNION ALL

    SELECT device_type, 'Order Confirmation', confirmation_sessions, 4
    FROM device_counts
),

funnel_rates AS (
    SELECT
        device_type,
        stage,
        sessions,
        LAG(sessions) OVER (
            PARTITION BY device_type
            ORDER BY stage_order
        ) AS previous_stage_sessions,
        stage_order
    FROM device_funnel
)

SELECT
    device_type,
    stage,
    sessions,
    previous_stage_sessions,

    ROUND(
        SAFE_DIVIDE(sessions * 100.0, previous_stage_sessions), 2
    ) AS conversion_rate,

    ROUND(
        100 - SAFE_DIVIDE(sessions * 100.0, previous_stage_sessions), 2
    ) AS drop_off_rate

FROM funnel_rates
ORDER BY device_type, stage_order;

-- 17. Validate order confirmation sessions against actual orders
WITH confirmation_sessions AS (
    SELECT DISTINCT website_session_id
    FROM cart_abandonment_analysis.website_pageviews
    WHERE pageview_url = '/thank-you-for-your-order'
),

order_sessions AS (
    SELECT DISTINCT website_session_id
    FROM cart_abandonment_analysis.orders
    WHERE website_session_id IS NOT NULL
)

SELECT
    COUNT(*) AS confirmation_sessions,

    COUNT(os.website_session_id) AS confirmation_sessions_with_orders,

    COUNT(*) - COUNT(os.website_session_id)
        AS confirmation_sessions_without_orders,

    (
        SELECT COUNT(*)
        FROM order_sessions os2
        LEFT JOIN confirmation_sessions cs2
            ON os2.website_session_id = cs2.website_session_id
        WHERE cs2.website_session_id IS NULL
    ) AS orders_without_confirmation_page

FROM confirmation_sessions cs
LEFT JOIN order_sessions os
    ON cs.website_session_id = os.website_session_id;
