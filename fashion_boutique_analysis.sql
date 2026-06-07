-- ═══════════════════════════════════════════════════════
-- PROJECT  : Boutique Fashion Retail — Sales Analytics
-- Tool     : MySQL Workbench
-- Dataset  : boutique_sales (2,176 rows | 13 columns)
-- Queries  : 6 (Cleaning + Revenue + Returns + Inventory
--             + Seasonal + Brand Ranking + Executive KPI)
-- ═══════════════════════════════════════════════════════

-- _______________________________________________________
-- Temporary Table: clean types and handle NULLs
-- _______________________________________________________
CREATE TEMPORARY TABLE cleaned_sales AS
  SELECT
    product_id,
    category,
    brand,
    season,
    COALESCE(NULLIF(size, ''), 'Unknown')  AS size,
    -- NULLs were loaded as empty strings '' instead of true NULLs
    color,
    original_price,
    markdown_percentage,
    current_price,
    -- Convert DD-MM-YYYY string to proper DATE
    STR_TO_DATE(purchase_date, '%d-%m-%Y')  AS purchase_date,
    stock_quantity,
    customer_rating,
    is_returned,
    -- Actual discount amount
    ROUND(original_price - current_price, 2) AS discount_amount,
    -- Flag: is the item on markdown?
    CASE WHEN markdown_percentage > 0
         THEN 'Marked Down'
         ELSE 'Full Price'
    END AS pricing_status
  FROM boutique_sales;

-- _____________________________________________________________________________________
-- 1. Revenue & Margin Summary by Brand
-- Which brands generate the highest revenue, and how much margin is lost to markdowns?
-- _____________________________________________________________________________________
SELECT
  brand,
  COUNT(*)                                     AS total_products,
  ROUND(SUM(original_price), 2)                AS gross_revenue,
  ROUND(SUM(current_price), 2)                 AS net_revenue,
  ROUND(SUM(discount_amount), 2)               AS total_markdown_loss,
  ROUND(AVG(markdown_percentage), 2)           AS avg_discount_pct,
  ROUND(SUM(discount_amount) / NULLIF(SUM(original_price), 0) * 100, 2) AS margin_erosion_pct
FROM cleaned_sales
GROUP BY brand
HAVING COUNT(*) > 50          -- Only brands with meaningful sample
ORDER BY gross_revenue DESC;

-- ___________________________________________________________
-- 2. Return Rate Analysis
-- Which categories and brands have problematic return rates?
-- ___________________________________________________________
SELECT *,
  CASE
    WHEN return_rate_pct >= 20 THEN 'High Risk'
    WHEN return_rate_pct BETWEEN 10 AND 19.99 THEN 'Monitor'
    ELSE 'Healthy'
  END AS return_risk_flag
FROM (
  SELECT
    category,
    brand,
    COUNT(*) AS total_sold,
    SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) AS total_returns,
    ROUND(SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate_pct,
    ROUND(AVG(customer_rating), 2) AS avg_rating,
    ROUND(SUM(CASE WHEN is_returned = 'True' THEN current_price ELSE 0 END), 2) AS returned_revenue
  FROM cleaned_sales
  GROUP BY category, brand
) AS return_analysis
ORDER BY return_rate_pct DESC;

-- ___________________________________________________________
-- 3. Inventory Health & Stockout Risk 
-- Which products are at risk of stockout vs overstocked?
-- ___________________________________________________________
SELECT
  product_id,
  brand,
  category,
  season,
  stock_quantity,
  original_price,
  customer_rating,
  CASE
    WHEN stock_quantity = 0      THEN 'Out of Stock'
    WHEN stock_quantity <= 5     THEN 'Critical — Reorder Now'
    WHEN stock_quantity <= 15    THEN 'Low Stock — Watch'
    WHEN stock_quantity >= 45    THEN 'Overstocked'
    ELSE ''
  END AS inventory_status,
  -- Flag high-rated items with low stock (priority reorder)
  CASE WHEN stock_quantity <= 10
        AND customer_rating >= 4.0
       THEN 'Priority Reorder'
       ELSE NULL
  END AS reorder_flag
FROM cleaned_sales
ORDER BY stock_quantity ASC, customer_rating DESC;

-- ___________________________________________________________________________________
-- 4. Seasonal Revenue Trends
-- How does revenue compare across seasons, and what is each season's share of total?
-- ___________________________________________________________________________________
With seasonal_totals AS (
  SELECT
    season,
    category,
    ROUND(SUM(current_price), 2)       AS season_category_revenue,
    COUNT(*)                           AS units_sold,
    ROUND(AVG(customer_rating), 2)     AS avg_rating
  FROM cleaned_sales
  GROUP BY season, category
)
 
SELECT
  season,
  category,
  season_category_revenue,
  units_sold,
  avg_rating,
  -- Running total within each season
  SUM(season_category_revenue)
    OVER (PARTITION BY season
          ORDER BY season_category_revenue DESC) AS cumulative_season_rev,
  -- Each category's % share of its season's revenue
  ROUND(season_category_revenue * 100.0 / SUM(season_category_revenue) OVER (PARTITION BY season), 2) AS pct_of_season
FROM seasonal_totals
ORDER BY season, pct_of_season DESC;


-- _______________________________________________________________
-- 5. Brand Performance Ranking
-- Brands Ranked by key performance metrics within each category.
-- _______________________________________________________________
With brand_metrics AS (
  SELECT
    brand,
    category,
    ROUND(AVG(customer_rating), 2)                                                     AS avg_rating,
    ROUND(AVG(markdown_percentage), 2)	 											   AS avg_discount,
    ROUND(SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2)  AS return_rate,
    COUNT(*)                           												   AS total_units
  FROM cleaned_sales
  GROUP BY brand, category
  HAVING COUNT(*) >= 10
)
 
SELECT
  brand,
  category,
  avg_rating,
  avg_discount,
  return_rate,
  RANK() OVER (PARTITION BY category ORDER BY avg_rating DESC)  AS rating_rank,
  RANK() OVER (PARTITION BY category ORDER BY return_rate )  AS return_rank,
  DENSE_RANK() OVER (PARTITION BY category ORDER BY avg_discount ) AS efficiency_rank
FROM brand_metrics
ORDER BY category, rating_rank;

-- ________________________________________________________________________________________________________________________
-- 6. Executive Summary
-- Since we can't use temporary table more than once in a single query, creating a cleaned sales CTE to bypass this issue.
-- ________________________________________________________________________________________________________________________
WITH cleaned_sales_CTE AS (
   SELECT
    product_id,
    category,
    brand,
    season,
    COALESCE(NULLIF(size, ''), 'Unknown')  AS size,
    -- NULLs were loaded as empty strings '' instead of true NULLs
    color,
    original_price,
    markdown_percentage,
    current_price,
    -- Convert DD-MM-YYYY string to proper DATE
    STR_TO_DATE(purchase_date, '%d-%m-%Y')  AS purchase_date,
    stock_quantity,
    customer_rating,
    is_returned,
    -- Actual discount amount
    ROUND(original_price - current_price, 2) AS discount_amount,
    -- Flag: is the item on markdown?
    CASE WHEN markdown_percentage > 0
         THEN 'Marked Down'
         ELSE 'Full Price'
    END AS pricing_status
  FROM boutique_sales
),

-- CTE 1: Key Performance Indicator
kpis AS (
  SELECT
    COUNT(*)                                      AS total_transactions,
    ROUND(SUM(current_price), 2)                  AS total_revenue,
    ROUND(AVG(customer_rating), 2)                AS overall_avg_rating,
    ROUND(AVG(markdown_percentage), 2)            AS avg_discount_pct,
    ROUND(SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overall_return_rate
  FROM cleaned_sales_CTE
),
-- CTE 2: Top brand by revenue
top_brand AS (
  SELECT brand, ROUND(SUM(current_price), 2) AS brand_revenue
  FROM cleaned_sales_CTE
  GROUP BY brand
  ORDER BY brand_revenue DESC
  LIMIT 1
),
-- CTE 3: Most returned category
worst_return AS (
  SELECT category,
    ROUND(SUM(CASE WHEN is_returned = 'True' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
    AS return_rate
  FROM cleaned_sales_CTE
  GROUP BY category
  ORDER BY return_rate DESC
  LIMIT 1
),
-- CTE 4: Highest rated category
best_category AS (
  SELECT category, ROUND(AVG(customer_rating), 2) AS avg_rating
  FROM cleaned_sales_CTE
  GROUP BY category
  ORDER BY avg_rating DESC
  LIMIT 1
)
-- Final: Join all CTEs into one executive row
SELECT
  k.total_transactions,
  k.total_revenue,
  k.overall_avg_rating,
  k.avg_discount_pct,
  k.overall_return_rate,
  t.brand         AS top_revenue_brand,
  t.brand_revenue,
  w.category      AS highest_return_category,
  w.return_rate   AS highest_return_rate,
  b.category      AS best_rated_category,
  b.avg_rating    AS best_category_rating
FROM kpis k
CROSS JOIN top_brand t
CROSS JOIN worst_return w
CROSS JOIN best_category b;


