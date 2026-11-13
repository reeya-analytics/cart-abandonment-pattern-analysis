# Python Analysis – Cart Abandonment Pattern Analysis

### 1. Objective

Use Python to independently validate SQL findings, investigate checkout funnel behaviour and create meaningful visualisations.

### 2. Libraries

- **Pandas:** Data manipulation and analysis.
- **NumPy:** Numerical calculations.
- **Matplotlib:** Data visualisation.
- **Seaborn:** Additional statistical visualisation, where required.

### 3. Analysis Scope

1. Import and inspect the datasets.
2. Validate data quality and SQL findings.
3. Verify checkout funnel metrics.
4. Visualise funnel conversion and drop-off.
5. Compare device-wise checkout behaviour.
6. Extract meaningful analytical insights.

**Deliverable:** Jupyter Notebook containing Python analysis, visualisations and findings.

## 1. Data Loading

The three raw CSV datasets were imported into Python using Pandas.

The datasets include:
- Website Sessions
- Website Pageviews
- Orders

The purpose of this step was to load the raw datasets into DataFrames so they could be inspected, validated and analysed.

## 2. Data Dimensions

| Dataset           | Rows      | Columns |
| Website Sessions  | 472,871   | 9 |
| Website Pageviews | 1,188,124 | 4 |
| Orders            | 32,313    | 8 |

**Purpose:** Load the raw datasets into Pandas DataFrames for further inspection, data quality assessment and analysis.

**Status:** Completed.

## 3. Dataset Inspection

The datasets were inspected using Pandas `head()` and `info()` to understand their structure, column names, data types and missing values.

### Key Observations

**Website Sessions**
- 472,871 rows and 9 columns.
- All ID and device-related columns have complete non-null counts.
- `utm_source`, `utm_campaign` and `utm_content` contain missing values.
- `http_referer` also contains missing values.
- `created_at` is stored as an object data type.

**Website Pageviews**
- 1,188,124 rows and 4 columns.
- All four columns have complete non-null counts.
- `website_pageview_id` and `website_session_id` are stored as `int64`.
- `created_at` was originally stored as `object`.
- `pageview_url` is stored as `object`.

**Orders**
- 32,313 rows and 8 columns.
- All columns have complete non-null counts.
- `created_at` is stored as an object data type.
- `price_usd` and `cogs_usd` are stored as float64.

### Initial Assessment

The date columns require conversion to datetime format for time-based analysis. Missing marketing and referral values will be investigated before deciding whether any treatment is necessary.

**Status:** Inspection in Progress.

### Website Pageviews — Inspection Findings

## 4. Date Conversion

The `created_at` column in all three datasets was converted from object to datetime format using Pandas `pd.to_datetime()`.

**Conversion Results**

| Dataset           | Converted Data Type | Invalid Dates |
| Website Sessions  | datetime64[ns]      | 0 |
| Website Pageviews | datetime64[ns]      | 0 |
| Orders            | datetime64[ns]      | 0 |

**Purpose:** Enable accurate date-based filtering, time-based analysis and chronological comparisons.

**Result:** All three date columns were converted successfully, with no invalid date values.

**Status:** Completed.

## 7. Duplicate Record Validation

Two checks were performed to identify duplicate records and verify primary ID uniqueness.

### Results

| Dataset           | Duplicate Rows | Duplicate Primary IDs |
| Website Sessions  | 0              | 0 |
| Website Pageviews | 0              | 0 |
| Orders            | 0              | 0 |

### Assessment

- No completely duplicated records were identified.
- All primary ID columns contain unique values.
- No duplicate records required removal.

**Result:** All three datasets passed the duplicate validation checks.

**Status:** Completed.

## 8. Dataset Relationship Validation

The relationships between the three datasets were checked using `website_session_id`.

### Validation Results

| Relationship Check   | Unmatched Records | Unmatched Sessions |
| Pageviews → Sessions | 0                 | 0 |
| Orders → Sessions    | 0                 | 0 |

### Assessment

- Every Pageview session ID exists in the Website Sessions dataset.
- Every Order session ID exists in the Website Sessions dataset.
- No unmatched records were identified.
- No records required removal or special treatment for these relationships.

**Result:** All three datasets passed session-level relationship validation.

**Status:** Completed.

# 9. Missing Value Analysis

Missing values were identified using Pandas `isnull().sum()` and `isnull().mean()`.

### Results

**Website Sessions**
- utm_source: 83,328 (17.62%)
- utm_campaign: 83,328 (17.62%)
- utm_content: 83,328 (17.62%)
- http_referer: 39,917 (8.44%)

**Website Pageviews:** No missing values.

**Orders:** No missing values.

### Treatment Decision

Missing values were limited to marketing and referral information in Website Sessions.

Since these fields are not required for checkout funnel calculations, no records were deleted and no values were imputed.

**Result:** All three datasets retained without missing-value treatment.

**Status:** Completed.


# 10. Data Consistency Checks

Pageview URLs and device categories were examined using Pandas `value_counts()`.

### Pageview URL Analysis
- Identified 16 distinct pageview URLs.
- Checkout-related pages include cart, shipping, billing and thank-you.
- Multiple landing pages and billing URLs were observed.

### Device Analysis

| Device | Sessions |
| Desktop | 327,027 |
| Mobile | 145,844 |

### Assessment
- Device categories are consistent.
- Pageview URLs contain identifiable website pages.
- No unexpected device categories were observed.

**Status:** In Progress.

# 11. Checkout Funnel Reconstruction

The four checkout funnel pages were extracted from Website Pageviews using Pandas.

### Funnel Stages
1. Product View – `/products`
2. Cart – `/cart`
3. Shipping – `/shipping`
4. Purchase – `/thank-you-for-your-order`

### Pageview Counts

| Funnel Stage | Pageviews |
|---|---:|
| Product View | 261,231 |
| Cart | 94,953 |
| Shipping | 64,484 |
| Purchase | 32,313 |

### Unique Session Analysis

Unique website sessions were calculated for each funnel stage using `groupby()` and `nunique()`.

The pageview counts and unique session counts were identical across all four stages.

### Chronological Funnel Reconstruction

The earliest timestamp for each funnel page was identified per session using `sort_values()`, `groupby()` and `unstack()`.

Sessions were then checked to verify whether they progressed through the funnel in chronological order.

### Sequential Funnel Results

| Funnel Stage | Sessions |
|---|---:|
| Product View | 261,231 |
| Cart | 94,953 |
| Shipping | 64,484 |
| Purchase | 32,313 |

**Result:** The checkout funnel was successfully reconstructed using Python.

**Status:** Completed.


# 12. Python and SQL Funnel Validation

The sequential funnel session counts calculated in Python were compared against the previously completed BigQuery results.

### Validation Results

| Funnel Stage | Python | SQL |
|---|---:|---:|
| Product View | 261,231 | 261,231 |
| Cart | 94,953 | 94,953 |
| Shipping | 64,484 | 64,484 |
| Purchase | 32,313 | 32,313 |

### Assessment
- All four funnel counts matched exactly.
- Python independently reproduced the SQL results.
- No differences were identified between the two analyses.

**Result:** Python funnel calculations successfully validated against BigQuery.

**Status:** Completed.


# 13. Conversion and Drop-off Analysis

Conversion and drop-off rates were calculated for each checkout funnel stage using Python.

### Results

| Stage | Sessions | Conversion Rate | Drop-off Rate |
| Product | 261,231 | 100.00% | 0.00% |
| Cart | 94,953 | 36.35% | 63.65% |
| Shipping | 64,484 | 67.91% | 32.09% |
| Purchase | 32,313 | 50.11% | 49.89% |

### Overall Conversion Rate

The overall conversion rate from Product View to Purchase was calculated as 12.37%.

### Key Findings
- The highest stage-to-stage drop-off occurred between Product View and Cart (63.65%).
- 32.09% of cart sessions did not progress to Shipping.
- 49.89% of shipping sessions did not reach Purchase.
- Overall, 12.37% of product-view sessions reached purchase confirmation.

### Business Interpretation

The Product-to-Cart transition represents the largest conversion gap.

The Shipping-to-Purchase transition also shows substantial abandonment and requires further investigation.

**Result:** Checkout conversion and drop-off rates successfully calculated.

**Status:** Completed.


# 14. Device-wise Checkout Analysis

### Objective

Compare desktop and mobile checkout performance to identify whether mobile users abandon checkout more frequently.

### Device Distribution

| Device | Product Sessions |
| Desktop | 192,325 |
| Mobile | 68,906 |

### Conversion Results

| Funnel Stage | Desktop (%) | Mobile (%) |
| Product → Cart | 39.08 | 28.73 |
| Cart → Shipping | 70.11 | 59.56 |
| Shipping → Purchase | 52.77 | 38.23 |

### Key Findings

- Mobile conversion was lower across all three checkout transitions.
- Mobile users showed the largest conversion gap during Shipping → Purchase.
- Overall desktop conversion was 14.45%, compared with 6.54% for mobile.
- Mobile overall conversion was approximately 54.7% lower than desktop.

### Business Interpretation

Mobile users demonstrate consistently higher checkout abandonment.

The business should investigate mobile checkout usability, form completion, shipping costs and payment experience to identify potential friction points.

### Result

Device-wise analysis identified mobile users as the weaker-converting customer segment.

**Status: Completed.**


# 15. Order Confirmation Validation

### Objective

Verify whether sessions visiting the order confirmation page have corresponding records in the Orders dataset.

### Results

| Validation Metric | Count |
| Confirmation Sessions | 32,313 |
| Confirmation Sessions With Orders | 32,313 |
| Confirmation Sessions Without Orders | 0 |
| Orders Without Confirmation Page | 0 |

### Key Findings

- All confirmation sessions had corresponding order records.
- No confirmation sessions existed without matching orders.
- All recorded orders had corresponding confirmation-page visits.

### Conclusion

The order confirmation page data matches the Orders dataset perfectly.

Python independently validated the SQL findings, confirming the reliability of using confirmation-page visits as an indicator of completed purchases.

**Status: Completed.**


## 15.1 Overall Checkout Funnel Visualisation

### Objective
Visualise session progression across the four checkout stages.

### Key Observation
The funnel shows a substantial decline in sessions between Product and Cart, followed by further losses across subsequent stages.

### Result
The visualisation highlights the Product-to-Cart transition as the largest drop-off area.

**Status: Completed.**

## 15.2 Device-wise Checkout Conversion Visualisation

### Objective
Compare desktop and mobile conversion rates across each checkout transition.

### Key Observations
- Desktop conversion is higher than mobile at all three transitions.
- The largest conversion gap occurs between Shipping and Purchase.
- Mobile conversion at the final transition is 38.23%, compared with 52.77% on desktop.

### Result
The visualisation highlights weaker mobile checkout performance, particularly during the Shipping-to-Purchase transition.

**Status: Completed.**


# 16. Final Business Insights and Recommendations

### Project Objective

Identify checkout funnel drop-offs, compare device-wise performance and highlight opportunities to improve e-commerce conversion.

### Key Findings

1. Overall checkout conversion was 12.37%.
2. The highest drop-off occurred between Product and Cart (63.65%).
3. Mobile overall conversion was 6.54%, compared with 14.45% for desktop.
4. Mobile users demonstrated lower conversion across all checkout transitions.
5. Shipping-to-Purchase conversion was 38.23% on mobile and 52.77% on desktop.
6. Python independently validated the SQL funnel and order validation results.

### Business Recommendations

- Investigate product-page engagement and add-to-cart behaviour.
- Improve mobile checkout usability and navigation.
- Review shipping costs and payment-related friction.
- Prioritise investigation of mobile checkout performance.
- Monitor funnel conversion rates to evaluate improvements.

### Final Conclusion

The analysis identified significant checkout drop-offs, particularly between Product and Cart.

Mobile users demonstrated consistently weaker conversion performance than desktop users.

These findings highlight opportunities to investigate checkout friction and improve the overall customer purchasing experience.

**Project Status: Python Analysis Completed.**