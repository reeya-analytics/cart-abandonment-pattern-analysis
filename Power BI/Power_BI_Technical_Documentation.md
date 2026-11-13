# Power BI Analysis – Cart Abandonment Pattern Analysis

## 1. Project Objective

Build an interactive Power BI dashboard to analyse e-commerce checkout funnel performance, identify major customer drop-off points and compare conversion behaviour across devices.

The dashboard aims to translate the findings from SQL and Python analysis into meaningful business insights and actionable recommendations.

### Business Question

Where in the checkout flow are customers dropping off the most, and what should the product team fix?

### Analysis Scope

- Checkout funnel progression and drop-off.
- Device-wise conversion performance.
- Identification of major checkout friction points.
- Interactive dashboard development.

## 2. Data Sources

Three CSV datasets were used for the analysis:

1. Website Sessions
2. Website Pageviews
3. Orders

These datasets were previously inspected, validated and analysed using SQL and Python.

## 3. Data Import

The three CSV datasets were imported into Power BI Desktop using the following process:

1. Opened Power BI Desktop.
2. Navigated to Home → Get Data → Text/CSV.
3. Selected and imported the Website Sessions dataset.
4. Repeated the process for Website Pageviews and Orders.
5. Selected Load to import the datasets directly into Power BI.

The datasets were loaded directly without additional Power Query cleaning because data quality checks and cleaning decisions had already been completed during the SQL and Python analysis.

### Imported Tables

- website_sessions
- website_pageviews
- orders

**Purpose:** Make the three datasets available in Power BI for data modelling, DAX calculations and dashboard development.

**Status:** Completed.

## 4. Data Validation

The imported datasets were checked in Power BI to verify that the records were loaded successfully.

### 4.1 Row Count Validation

The row counts displayed in Power BI were compared against the original dataset dimensions established during Python analysis.

| Dataset | Expected Rows | Power BI Rows |
|---|---:|---:|
| Website Sessions | 472,871 | 472,871 |
| Website Pageviews | 1,188,124 | Pending |
| Orders | 32,313 | Pending |

**Finding:** The Website Sessions dataset contains the expected 472,871 records after import.

**Status:** In Progress.

## 5. Data Modelling and Relationships

### 5.1 Table Structure

The three datasets were used to establish the data model:

- **website_sessions:** Contains website session-level information.
- **website_pageviews:** Contains individual pageview records associated with website sessions.
- **orders:** Contains completed purchase records associated with website sessions.

### 5.2 Relationship Creation

Relationships were established using the common `website_session_id` column.

The following relationships were configured:

| Primary Table | Related Table | Join Column | Cardinality |
|---|---|---|---|
| website_sessions | website_pageviews | website_session_id | One-to-many |
| website_sessions | orders | website_session_id | One-to-many |

### 5.3 Relationship Configuration

The relationships were configured using the following settings:

- Cardinality: One-to-many (1:*)
- Cross-filter direction: Single
- Relationship status: Active

### 5.4 Data Model Structure

The website_sessions table acts as the central table connecting website navigation records and completed orders.

The model allows analysis of customer session information alongside pageview activity and purchase records.

**Status:** Pending verification.

## 6. DAX measures

### 6.1 Product Sessions Measure

**Objective:** Calculate the number of unique website sessions that visited the product page.

**DAX Measure:**

```dax
Product Sessions =
CALCULATE(
    DISTINCTCOUNT(website_pageviews[website_session_id]),
    website_pageviews[pageview_url] = "/products"
)
```

**Result:** 261,231 unique sessions.

**Explanation:**
- `CALCULATE()` applies the specified filter context.
- `DISTINCTCOUNT()` counts each website session only once.
- The page URL filter includes records associated with the `/products` page.

**Validation:** The result matches the previously calculated SQL and Python results.

**Status:** Completed.

### 6.2 Cart Sessions Measure

**Objective:** Calculate the number of unique website sessions that visited the cart page.

**DAX Measure:**

```dax
Cart Sessions =
CALCULATE(
    DISTINCTCOUNT(website_pageviews[website_session_id]),
    website_pageviews[pageview_url] = "/cart"
)
```

**Result:** 94,953 unique sessions.

**Explanation:**
- `CALCULATE()` applies the specified filter context.
- `DISTINCTCOUNT()` counts each website session only once.
- The page URL filter selects records associated with the `/cart` page.

**Validation:** The result matches the previously calculated SQL and Python results.

**Status:** Completed.


### 6.3 Shipping Sessions Measure

**Objective:** Calculate the number of unique website sessions that visited the shipping page.

**DAX Measure:**

```dax
Shipping Sessions =
CALCULATE(
    DISTINCTCOUNT(website_pageviews[website_session_id]),
    website_pageviews[pageview_url] = "/shipping"
)
```

**Result:** 64,484 unique sessions.

**Explanation:**
- `CALCULATE()` applies the specified filter context.
- `DISTINCTCOUNT()` counts each website session only once.
- The page URL filter selects records associated with the `/shipping` page.

**Validation:** The result matches the previously calculated SQL and Python results.

**Status:** Completed.

### 6.4 Completed Purchases Measure

**Objective:** Calculate the number of unique website sessions that reached the order confirmation page.

**DAX Measure:**

```dax
Completed Purchases =
CALCULATE(
    DISTINCTCOUNT(website_pageviews[website_session_id]),
    website_pageviews[pageview_url] = "/thank-you-for-your-order"
)
```

**Result:** 32,313 completed purchase sessions.

**Explanation:**
- `CALCULATE()` applies the specified filter context.
- `DISTINCTCOUNT()` counts each website session only once.
- The page URL filter selects sessions that reached the order confirmation page.

**Validation:** The result matches the previously calculated SQL and Python results and the Orders table validation.

**Status:** Completed.

### 6.5 Overall Conversion Rate Measure

**Objective:** Calculate the percentage of product-view sessions that resulted in completed purchases.

**DAX Measure:**

```dax
Overall Conversion Rate =
DIVIDE(
    [Completed Purchases],
    [Product Sessions],
    0
)
```

**Result:** 12.37%.

**Explanation:**
- `DIVIDE()` calculates the ratio between completed purchases and product sessions.
- The third argument returns 0 if the denominator is zero.
- The result represents the overall conversion rate from Product View to Purchase.

**Validation:** The result matches the previously calculated SQL and Python findings.

**Status:** Completed.

---

### 6.6 Largest Drop-off Measure

**Objective:** Calculate the drop-off rate between Product and Cart, identifying the largest observed loss of sessions in the checkout funnel.

**DAX Measure:**

```dax
Largest Drop-off =
1 - [Product to Cart Conversion]
```

**Result:** 63.65%.

**Explanation:**
- Subtracts the Product-to-Cart conversion rate from 1.
- Represents the percentage of product sessions that did not progress to the Cart stage.
- The result is formatted as a percentage with two decimal places.

**Validation:** The result matches the previously calculated SQL and Python findings.

**Status:** Completed.

### 6.7 Funnel Stage Table

**Objective:** Create an ordered list of checkout funnel stages for dashboard visualisation.

**Implementation:**

A calculated table named `Funnel Stages` was created using DAX
DATATABLE() with two columns:

- Stage
- Stage Order

The table contains Product, Cart, Shipping and Purchase stages.

The Stage column was sorted by Stage Order to maintain the
correct checkout sequence.

**Purpose:** Provide an ordered category field for the funnel visual.

**Status:** Completed.

### 6.8 Device-wise Conversion Measures

**Objective:** Calculate stage-to-stage checkout conversion rates separately for desktop and mobile users.

**Implementation:**

Six DAX measures were created using the device-wise session counts obtained from SQL analysis.

**Desktop Conversion Measures:**

| Transition | Sessions | Conversion Rate |
| Product → Cart | 75,155 / 192,325 | 39.08% |
| Cart → Shipping | 52,692 / 75,155 | 70.11% |
| Shipping → Purchase | 27,805 / 52,692 | 52.77% |

**Mobile Conversion Measures:**

| Transition | Sessions | Conversion Rate |
| Product → Cart | 19,798 / 68,906 | 28.73% |
| Cart → Shipping | 11,792 / 19,798 | 59.56% |
| Shipping → Purchase | 4,508 / 11,792 | 38.23% |

**Visualisation:** Clustered Column Chart.

**Chart Configuration:**
- X-axis: Checkout transitions.
- Y-axis: Desktop and Mobile conversion measures.
- Desktop: Blue.
- Mobile: Orange.

**Key Findings:**
- Desktop conversion was higher across all three transitions.
- The largest device conversion gap occurred between Shipping and Purchase.
- Mobile users demonstrated consistently weaker checkout conversion.

**Purpose:** Compare device-wise conversion performance and identify stages where mobile users experience greater drop-off.

**Status:** Completed.


### 6.9 Device-wise Session Distribution

**Objective:** Visualise the distribution of product-view sessions across desktop and mobile devices.

**DAX Measure:**

`Device Sessions` was created using `CALCULATE()` and `DISTINCTCOUNT()` to count unique product-view sessions.

**Visualisation:** Donut Chart.

**Chart Configuration:**
- Legend: Device Type.
- Values: Device Sessions.
- Desktop: Blue.
- Mobile: Orange.
- Data labels: Category and percentage of total.

**Results:**

| Device | Product Sessions | Distribution |
| Desktop | 192,325 | 73.62% |
| Mobile | 68,906 | 26.38% |
| **Total** | **261,231** | **100%** |

**Key Finding:** Desktop users account for the majority of product-view sessions.

**Purpose:** Understand the device composition of website visitors and provide context for device-wise checkout conversion analysis.

**Status:** Completed.

## 7. Dashboard Overview

### 7.1 Dashboard Components

The Power BI dashboard brings together the key findings from the e-commerce checkout funnel analysis through four KPI cards and four visualisations.

**KPI Cards:**
- Product Sessions: 261,231
- Completed Purchases: 32,313
- Overall Conversion Rate: 12.37%
- Largest Drop-off: 63.65%

**Visualisations:**

| Visualisation | Purpose |
|---|---|
| Funnel Chart | Displays customer progression from Product to Purchase. |
| Clustered Column Chart | Compares Desktop and Mobile conversion rates across checkout transitions. |
| Donut Chart | Shows the distribution of product-view sessions by device. |
| Horizontal Bar Chart | Compares drop-off rates across checkout transitions and highlights the largest drop-off. |

### 7.2 Key Dashboard Findings

- Only 12.37% of product-view sessions resulted in a completed purchase.
- Product-to-Cart recorded the highest drop-off at 63.65%.
- Shipping-to-Purchase recorded a drop-off of 49.89%.
- Mobile conversion rates were lower than Desktop conversion rates across all three checkout transitions.
- The largest device-wise conversion gap occurred between Shipping and Purchase.

### 7.3 Business Recommendations

- Investigate product-page engagement and add-to-cart behaviour to understand the high initial drop-off.
- Review the mobile shopping experience and identify usability issues.
- Examine the shipping and payment stages for potential friction.
- Monitor checkout conversion rates across devices to evaluate improvements.

### 7.4 Conclusion

The Power BI dashboard provides an interactive overview of checkout funnel performance, helping identify major customer drop-off points and differences in device-wise conversion behaviour.

It translates the SQL and Python findings into clear visual insights that can support data-driven product and business decisions.

**Status:** Completed.