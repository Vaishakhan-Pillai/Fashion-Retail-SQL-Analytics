# Boutique Fashion Retail — SQL Sales & Inventory Analysis

## Project Overview
End-to-end SQL analysis of 2,176 boutique retail transactions across 
8 brands and 6 product categories. The project mirrors a real-world 
retail analytics workflow — from raw data cleaning to executive KPI reporting.

**Tool:** MySQL Workbench  
**Dataset:** 2,176 rows · 13 columns · 8 brands · 6 categories  

---

## Business Questions Answered
1. Which brands generate the most revenue, and how much is lost to markdowns?
2. Which category–brand combinations have dangerous return rates?
3. Which products face stockout risk vs. overstock?
4. How does revenue share differ across seasons and categories?
5. How do brands rank against each other within the same category?
6. What does the overall business KPI picture look like in one view?

---

## SQL Techniques Used
| Technique | Query |
|---|---|
| Temporary Table + CTE | Staging / Data Cleaning |
| STR_TO_DATE, COALESCE, NULLIF | Data Cleaning |
| GROUP BY, HAVING, ROUND | Query 1 — Revenue |
| CASE WHEN, Subquery | Query 2 — Returns |
| Multi-condition CASE tiering | Query 3 — Inventory |
| SUM OVER, PARTITION BY | Query 4 — Seasonal Trends |
| RANK(), DENSE_RANK() | Query 5 — Brand Ranking |
| 4-CTE + CROSS JOIN | Query 6 — Executive Dashboard |

---

## Key Findings
- Overall return rate: **14.7%** — above healthy retail benchmark
- Empty string NULLs discovered in Size column during cleaning (89 records)
- Markdown applied to majority of products; clearance-tier items 
  show no improvement in ratings or returns
- High-rated low-stock items identified for priority reorder

---

## Files
| File | Description |
|---|---|
| `boutique_sales.csv` | Raw dataset |
| `fashion_boutique_analysis.sql` | Complete project — staging layer, data cleaning, and all 6 analysis queries |

---

## Note on Workflow
Leveraged Claude and Gemini to frame business questions and accelerate debugging. All queries were written, tested, and debugged 
independently in MySQL Workbench.
