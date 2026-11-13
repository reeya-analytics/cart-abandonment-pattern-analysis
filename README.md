# Cart Abandonment Pattern Analysis

An end-to-end e-commerce funnel analysis using **SQL, Python and Power
BI** to identify where website sessions fail to progress through
checkout and how conversion differs between desktop and mobile users.

> **Core question:** Where in the checkout flow are customers dropping
> off the most, and what should the product team investigate?

## Dashboard

![Power BI dashboard](https://1drv.ms/i/c/21a5a2c07f8f375e/IQCYEJxZPDliSJXZMR7--hsQAUjw2laOR9H54fUq1KHkfQw?e=bnTZnB)

The Power BI dashboard includes: - KPI cards for product sessions,
completed purchases, overall conversion and largest drop-off - Checkout
funnel from Product to Purchase - Desktop vs. mobile conversion by
checkout transition - Product-session distribution by device - Drop-off
comparison across checkout transitions - A Device Type slicer for
interactive filtering

## Key findings

  Metric                                                      Result
  ---------------------------------------- -------------------------
  Website sessions                                           472,871
  Website pageviews                                        1,188,124
  Orders                                                      32,313
  Product-page sessions                                      261,231
  Completed purchase sessions                                 32,313
  Overall Product-to-Purchase conversion                      12.37%
  Largest stage-to-stage drop-off            63.65% (Product → Cart)

### Funnel performance

  Transition              Sessions at next stage   Conversion   Drop-off
  --------------------- ------------------------ ------------ ----------
  Product → Cart                          94,953       36.35%     63.65%
  Cart → Shipping                         64,484       67.91%     32.09%
  Shipping → Purchase                     32,313       50.11%     49.89%

### Device comparison

  Transition              Desktop conversion   Mobile conversion
  --------------------- -------------------- -------------------
  Product → Cart                      39.08%              28.73%
  Cart → Shipping                     70.11%              59.56%
  Shipping → Purchase                 52.77%              38.23%

Desktop conversion was higher at every measured transition. The largest
desktop--mobile gap was at Shipping → Purchase (14.54 percentage
points). Overall conversion was 14.45% for desktop and 6.54% for mobile.

## Business interpretation

1.  **Product → Cart is the largest loss point.** The 63.65% drop-off
    makes product-page engagement and the add-to-cart journey the first
    areas to investigate.
2.  **Mobile users convert less consistently.** Mobile conversion is
    lower at all three transitions, so mobile navigation, page
    performance and form usability deserve review.
3.  **The final checkout step also needs attention.** Nearly half of
    Shipping sessions do not reach purchase confirmation. Shipping-cost
    presentation, payment experience and form errors are possible areas
    to investigate, not confirmed causes.

## Project workflow

### 1. SQL --- Google BigQuery

-   Validated table dimensions, identifiers, duplicates, missing
    identifiers and table relationships.
-   Checked data types and observation date ranges.
-   Reconstructed the selected checkout funnel using unique sessions.
-   Calculated stage conversion, drop-off and device-wise performance.
-   Validated purchase-confirmation sessions against the Orders table.

### 2. Python --- Jupyter Notebook

-   Loaded the three CSV datasets with Pandas.
-   Inspected data structure, types and missing values.
-   Converted date columns to datetime.
-   Checked duplicate records and session relationships.
-   Reconstructed the funnel and independently validated SQL results.
-   Calculated conversion and drop-off rates.
-   Created funnel and device-wise visualisations.

### 3. Power BI

-   Imported the three datasets and created relationships using
    `website_session_id`.
-   Built DAX measures for funnel stages, conversion and drop-off.
-   Created KPI cards and funnel/device visualisations.
-   Added a Device Type slicer for interactive filtering.

## Data

Source: [Maven Analytics -- Toy Store E-commerce
Database](https://mavenanalytics.io/data-playground/toy-store-e-commerce-database)

Three CSV tables were used:

  ------------------------------------------------------------------------
  Table                                         Rows Role
  --------------------- ---------------------------- ---------------------
  `website_sessions`                         472,871 Session-level
                                                     attributes, including
                                                     device type

  `website_pageviews`                      1,188,124 Page visits used to
                                                     reconstruct funnel
                                                     progression

  `orders`                                    32,313 Purchase records used
                                                     for validation
  ------------------------------------------------------------------------

The source data covers approximately three years, from 19 March 2012 to
19 March 2015.

## Repository structure

``` text
Cart-Abandonment-Pattern-Analysis/
│
├── Documentation/
│   ├── Project_Brief
│   ├── Data_Dictionary
│   ├── SQL_Documentation
│   ├── Python_Documentation
│   ├── PowerBI_Documentation
│   ├── Executive_Summary
│   └── Analysis_Report
│
├── SQL/
│   └── BigQuery analysis queries
│
├── Python/
│   └── Jupyter Notebook
│
├── PowerBI/
│   └── Power BI report (.pbix)
│
└── Outputs/
    └── Cart_Abandonment_Dashboard.png
```

Adjust filenames in this tree to match the actual files in the
repository.

## How to explore the project

1.  Review the project brief and data dictionary in `Documentation/`.
2.  Open the SQL scripts in `SQL/` to follow the data validation and
    funnel calculations.
3.  Open the Jupyter Notebook in `Python/` to review the Python workflow
    and validation.
4.  Open the `.pbix` file in Power BI Desktop to interact with the
    dashboard.
5.  Refer to the analysis report for the full methodology, findings,
    limitations and recommendations.

The source CSV files must be available locally and the Power BI file may
need its data-source paths updated when opened on another computer.
BigQuery SQL scripts require access to the relevant dataset and a
configured Google Cloud project.

## Data quality and validation

The analysis included checks for: - Duplicate primary IDs and duplicate
records - Missing key identifiers - Unmatched pageview/session and
order/session relationships - Date parsing and data types - Consistency
of funnel counts between SQL and Python

The four funnel-stage session counts matched exactly between BigQuery
and Python. All 32,313 purchase-confirmation sessions matched records in
the Orders table.

## Scope and limitations

-   This completed project focuses on **checkout funnel progression and
    device-wise conversion**.
-   Product-category and time-of-day analyses were part of the initial
    project idea but were not completed in this version.
-   Funnel drop-off indicates that a session did not progress to the
    next selected page; it does not establish why the visitor left.
-   Device comparisons are descriptive and do not prove that device type
    caused the conversion difference.
-   The dataset is historical (2012--2015), so findings should not be
    treated as current market benchmarks.

## Recommendations

-   Investigate product-page engagement and the add-to-cart journey.
-   Review mobile checkout usability, page performance and form
    completion.
-   Examine the shipping-to-purchase experience, including shipping-cost
    communication and payment flow.
-   Monitor conversion by stage and device, and use controlled tests
    where possible to evaluate improvements.

## Tools and skills demonstrated

**SQL:** BigQuery, filtering, aggregation, joins, subqueries,
conditional logic, session-level analysis and validation.

**Python:** Pandas, NumPy, Matplotlib, Seaborn, data inspection,
datetime conversion, data quality checks, funnel analysis and
visualisation.

**Power BI:** Data modelling, relationships, DAX measures, KPI cards,
funnel chart, clustered column chart, donut chart, horizontal bar chart
and slicers.

------------------------------------------------------------------------

*This project was completed as a portfolio exercise using the Maven
Analytics Toy Store E-commerce Database.*