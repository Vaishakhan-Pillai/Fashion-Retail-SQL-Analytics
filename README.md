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
## Results Preview

### Query 1 — Revenue & Margin by Brand
<img width="855" height="205" alt="1  Revenue   Margin Summary by Brand" src="https://github.com/user-attachments/assets/fab856ef-393e-417a-bcfe-ab4a4edc5304" />

### Query 2 — Return Rate Analysis
<img width="845" height="431" alt="2  Return Rate Analysis" src="https://github.com/user-attachments/assets/69ba992b-75fa-49fc-b9a2-1f75c15ca1bf" />

### Query 3 — Inventory Health & Stockout Risk
<img width="1035" height="427" alt="3  Inventory Health   Stockout Risk" src="https://github.com/user-attachments/assets/7fb6d35a-e082-4bd9-9fb7-af16957dcb65" />

### Query 4 — Seasonal Revenue Trends
<img width="783" height="432" alt="4  Seasonal Revenue Trends" src="https://github.com/user-attachments/assets/09e4cb95-aa99-4c74-8ecf-569968949e02" />

### Query 5 — Brand Performance Ranking
<img width="790" height="433" alt="5  Brand Performance Ranking" src="https://github.com/user-attachments/assets/b244b628-4f39-49f6-a8ce-e0f6bc7014f6" />

### Query 6 — Executive Summary
<img width="1542" height="51" alt="6  Executive Summary" src="https://github.com/user-attachments/assets/5d2a3758-0ece-4e6a-b1cf-ab58b9181abb" />



---

## Key Findings
- Overall return rate: **14.7%** — above healthy retail benchmark
- Empty string NULLs discovered in the Size column during cleaning (89 records)
- Markdown applied to the majority of products; clearance-tier items 
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
