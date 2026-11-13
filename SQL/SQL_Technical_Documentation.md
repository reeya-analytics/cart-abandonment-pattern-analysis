# SQL Analysis – Cart Abandonment Pattern Analysis

## 1. Website Sessions — Record Validation

**Objective:** Verify the total number of session records and unique website sessions.

**Results:**

| Metric          | Result |
| Total records   | 472,871 |
| Unique sessions | 472,871 |

**Finding:** All 472,871 records represent unique website sessions. No duplicate session IDs were identified.

## 2. Website Pageviews — Record Validation

**Objective:** Identify the total number of pageview records and unique website sessions.

**Results:**

| Metric          | Result |
| Total pageviews | 1,188,124 |
| Unique sessions | 472,871 |

**Finding:** The website pageviews table contains 1,188,124 records across 472,871 unique website sessions.

## 3. Average Pageviews per Session

**Objective:** Calculate the average number of pages viewed during each website session.

**Result:**

| Metric                        | Result |
| Average pageviews per session | 2.51 |

**Finding:** Visitors viewed an average of 2.51 pages per session, providing an initial measure of website engagement.

## 4. Duplicate Session ID Check

**Objective:** Identify duplicate `website_session_id` values in the website sessions table.

**Result:** No data returned.

**Finding:** No duplicate session IDs were found. Each session ID occurs only once.

## 5. Duplicate Pageview ID Check

**Objective:** Identify duplicate `website_pageview_id` values in the website pageviews table.

**Result:** No data returned.

**Finding:** No duplicate pageview IDs were found. Each pageview ID is unique.

## 6. Missing Session ID Check

**Objective:** Identify NULL values in `website_session_id` in the website sessions table.

**Result:**

| Metric | Result |
| Missing session IDs | 0 |

**Finding:** No missing session IDs were identified.

## 7. Missing Pageview and Session ID Check

**Objective:** Identify missing identifiers in the website pageviews table.

**Results:**

| Metric               | Result |
| Missing pageview IDs | 0 |
| Missing session IDs  | 0 |

**Finding:** Both identifier columns are complete, with no NULL values detected.

## 8. Pageviews Generated per Session

**Objective:** Determine how many pageviews each website session generated and identify sessions with multiple pageviews.

**Results:**

- Total sessions returned: 261,231
- Each result row represents one session with more than one pageview.
- The highest pageview count visible in the displayed results is 7.

**Finding:** 261,231 website sessions generated more than one pageview. This indicates that a substantial number of visitors navigated across multiple pages during their sessions.

**Business relevance:** Understanding pageview patterns helps evaluate website engagement and customer navigation behaviour. These patterns can later be compared with checkout progression and abandonment to identify potential friction points.

## 9. Comparison of Total Pageviews and Unique Sessions

**Objective:** Compare total pageview records with unique website sessions to determine the number of additional pageviews generated within sessions.

**Results:**

| Metric                      | Result |
| Total pageviews             | 1,188,124 |
| Unique sessions             | 472,871 |
| Additional pageview records | 715,253 |

**Finding:** The website generated 1,188,124 pageviews across 472,871 unique sessions. After accounting for the first pageview of each session, 715,253 additional pageview records remain.

**Business relevance:** This indicates that visitors navigated through multiple pages during their sessions. Understanding these navigation patterns will help evaluate customer engagement and identify potential drop-off points in the checkout journey.

## 10. Session ID Relationship Validation

**Objective:** Identify pageview sessions that do not have a corresponding record in the website sessions table.

**Result:**

| Metric                      | Result |
| Unmatched pageview sessions | 0 |

**Finding:** All distinct session IDs in the website pageviews table have corresponding records in the website sessions table. No unmatched pageview sessions were identified.

**Conclusion:** The session ID relationship between the two tables is consistent, supporting reliable analysis of customer navigation behaviour.

## 11. Column Names and Data Type Validation

**Objective:** Verify column names, data types and NULL settings in the website sessions and website pageviews tables.

**Results:**

- Both tables contain the expected columns.
- The `created_at` column is stored as `TIMESTAMP` in both tables.
- All other columns have appropriate data types.
- No data type issues were identified.

**Finding:** Both tables have suitable data types for further analysis. The TIMESTAMP format supports time-based analysis, including session timing and customer behaviour throughout the day.

**Conclusion:** Column structure and data types are validated for both tables.

## 12. Date Range Validation of Unmatched Pageview Sessions

**Objective:** Determine the date range and total number of pageview sessions that do not have corresponding records in the website sessions table.

**Results:**

| Metric | Result |
| First unmatched session date | NULL |
| Last unmatched session date | NULL |
| Unmatched sessions | 0 |

**Finding:** No unmatched pageview sessions were identified. Consequently, the minimum and maximum dates returned NULL because there were no records available for date-range calculation.

**Conclusion:** The pageview-to-session relationship remains consistent, with no unmatched sessions across the available dataset.

## 13. Date Range Comparison of Website Tables

**Objective:** Compare the earliest and latest timestamps in the website sessions and website pageviews tables to verify their observation periods.

**Results:**

| Table | First Record (UTC) | Last Record (UTC) |
| website_sessions | 2012-03-19 08:04:16 | 2015-03-19 07:59:08 |
| website_pageviews | 2012-03-19 08:04:16 | 2015-03-19 07:59:32 |

**Findings:**
- Both tables begin at the same timestamp.
- Both tables cover approximately three years of website activity.
- The last pageview timestamp is 24 seconds later than the last session timestamp.

**Conclusion:** Both tables have consistent overall observation periods, with a minor difference in their latest recorded timestamps.

---

## 14. Unique Sessions Visiting Key Website Pages

**Objective:** Identify visitor traffic across the main stages of the e-commerce customer journey.

**Results:**

| Page URL | Unique Sessions |
| /products | 261,231 |
| /cart | 94,953 |
| /shipping | 64,484 |
| /thank-you-for-your-order | 32,313 |

**Key Findings:**
- `/products` recorded the highest traffic among the selected pages.
- `/cart` and `/shipping` recorded considerably fewer unique sessions.
- 32,313 unique sessions visited the purchase-completion page.

**Business Relevance:** These pages represent key stages of the shopping journey. Comparing their visitor counts provides an initial understanding of customer navigation and potential checkout friction.

**Note:** Other URLs, including billing-page variations, are excluded from this summary. Page-level counts do not independently establish sequential conversion or abandonment rates.

---

## 15. Checkout Funnel Progression Analysis

**Objective:** Calculate the number of unique sessions progressing through the checkout journey in chronological order.

**Results:**

| Funnel Stage | Unique Sessions |
|---|---:|
| Product browsing | 261,231 |
| Cart | 94,953 |
| Shipping | 64,484 |
| Completed purchases (Thank You page) | 32,313 |

**Key Findings:**
- 94,953 sessions progressed from product browsing to cart.
- 64,484 sessions progressed to shipping.
- 32,313 sessions reached the purchase-completion page.
- Approximately 12.4% of product sessions completed the selected checkout journey.

**Business Relevance:** The funnel highlights a decline in sessions across successive checkout stages. Further analysis is required to identify the stages with the highest customer drop-offs and potential opportunities for improving checkout conversion.

**Note:** The analysis considers sessions that visited the selected pages in chronological order. Purchase completion is identified through the thank-you page and will be validated against the orders table.

---

## 16. Checkout Funnel Conversion and Drop-off Analysis

**Objective:** Calculate stage-to-stage conversion rates, customer drop-offs and sessions lost across the checkout funnel.

**Results:**

| Funnel Stage       | Sessions | Sessions Lost | Conversion Rate | Drop-off Rate |
| Product            | 261,231  | —             | —               | —      |
| Cart               | 94,953   | 166,278       | 36.35%          | 63.65% |
| Shipping           | 64,484   | 30,469        | 67.91%          | 32.09% |
| Order Confirmation | 32,313   | 32,171        | 50.11%          | 49.89% |

**Key Findings:**
- The highest drop-off occurred between Product and Cart (63.65%).
- The Cart-to-Shipping conversion rate was 67.91%.
- The Shipping-to-Order Confirmation drop-off rate was 49.89%.

**Business Relevance:** The Product-to-Cart transition represents the largest observed drop-off opportunity. The business should investigate product-page engagement, cart additions and checkout friction to understand the reasons behind these losses.

**Note:** Rates are calculated between consecutive stages of the selected chronological funnel. Drop-offs indicate sessions that did not progress to the next selected stage, not necessarily confirmed cart abandonment.

---

## 17. Checkout Funnel Performance Across Devices

**Objective:** Compare checkout funnel progression, conversion rates and drop-off rates between desktop and mobile users.

**Results:**

| Funnel Stage       | Desktop Sessions | Mobile Sessions |
| Product            | 192,325          | 68,906 |
| Cart               | 75,155           | 19,798 |
| Shipping           | 52,692           | 11,792 |
| Order Confirmation | 27,805           | 4,508 |

**Stage-to-Stage Conversion Rates:**

| Transition              | Desktop | Mobile |
| Product → Cart          | 39.08% | 28.73% |
| Cart → Shipping         | 70.11% | 59.56% |
| Shipping → Confirmation | 52.77% | 38.23% |

**Key Findings:**

1. Desktop users demonstrated higher conversion rates at every checkout stage.
2. Mobile Product-to-Cart conversion was 10.35 percentage points lower than desktop.
3. The largest conversion gap occurred between Shipping and Order Confirmation (14.54 percentage points).
4. Mobile users experienced higher drop-off rates throughout the checkout funnel.

**Business Recommendations:**

- Investigate mobile checkout usability and navigation.
- Review shipping forms and their mobile experience.
- Examine potential payment-related friction.
- Prioritize mobile checkout optimization to improve purchase completion.

**Conclusion:** Mobile users showed consistently weaker checkout performance than desktop users. Improving the mobile checkout experience could represent an important opportunity to increase completed orders.

**Note:** Findings represent observed differences and do not establish the underlying causes of abandonment.

---

## 18. Validate Order Confirmation Sessions Against Actual Orders

**Objective:** Verify whether sessions visiting the order confirmation page have corresponding records in the orders table.

**Results:**

| Validation Metric | Count |
| Confirmation Sessions | 32,313 |
| Confirmation Sessions With Orders | 32,313 |
| Confirmation Sessions Without Orders | 0 |
| Orders Without Confirmation Page | 0 |

**Key Findings:**

1. All 32,313 confirmation sessions had corresponding order records.
2. No confirmation sessions existed without a matching order.
3. All recorded orders had corresponding order confirmation page visits.

**Conclusion:** The order confirmation page data matches the actual orders table perfectly. This validates the use of order confirmation page visits as an indicator of completed purchases in this analysis.