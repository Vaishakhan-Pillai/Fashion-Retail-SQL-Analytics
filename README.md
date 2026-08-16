# Boutique Fashion Retail — SQL Sales & Inventory Analysis
 
## What this project is
 
An independent, end-to-end SQL analysis of 2,176 boutique retail transactions across 8 brands and 6 product categories — built to answer the kind of questions a retail operations or merchandising team actually asks: *where is revenue leaking, what's overstocked, what's about to run out, and which products need a second look.*
 
**Dataset:** 2,176 rows · 13 columns · 8 brands · 6 categories
**Source:** Public retail transactions dataset, Kaggle
**Tool:** MySQL Workbench

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

Zara leads on both revenue (₹29,967) and margin discipline — its 11.43% margin erosion is well below peers. Gap sits at the opposite end: lowest revenue of the eight brands but the highest average discount (14.12%) and highest margin erosion (14.71%). Uniqlo stands out as the most efficient operator — strong revenue (₹26,192) with the lowest discount rate (8.92%) of any brand.

### Query 2 — Return Rate Analysis
<img width="845" height="431" alt="2  Return Rate Analysis" src="https://github.com/user-attachments/assets/69ba992b-75fa-49fc-b9a2-1f75c15ca1bf" />

Ten brand-category combinations were flagged "High Risk." The standout isn't the highest percentage — it's Ann Taylor–Outerwear at 23.4%, which represents ₹1,535.57 in returned revenue, the largest dollar impact in the entire risk list. Outerwear appears three separate times across the High Risk list (Ann Taylor, Gap, H&M) — a category-level pattern, not a one-brand problem.

### Query 3 — Inventory Health & Stockout Risk
<img width="1035" height="427" alt="3  Inventory Health   Stockout Risk" src="https://github.com/user-attachments/assets/7fb6d35a-e082-4bd9-9fb7-af16957dcb65" />

Every row is a product at zero stock — what matters is which ones get flagged for reorder. Items rated 4.1★ and above are tagged "Priority Reorder"; items rated below roughly 4.0 are deliberately left unflagged. This turns a stockout list into a prioritized reorder action list, not just a shortage report.

### Query 4 — Seasonal Revenue Trends
<img width="783" height="432" alt="4  Seasonal Revenue Trends" src="https://github.com/user-attachments/assets/09e4cb95-aa99-4c74-8ecf-569968949e02" />

Outerwear is the single highest-revenue category in every season shown — Fall (27.4% of seasonal revenue), Spring (28.8%), Summer (25.1%), and Winter — the most consistent, season-proof revenue driver in the catalog.

### Query 5 — Brand Performance Ranking
<img width="790" height="433" alt="5  Brand Performance Ranking" src="https://github.com/user-attachments/assets/b244b628-4f39-49f6-a8ce-e0f6bc7014f6" />

Ranking brands within each category, rather than as one blended average, surfaces inconsistency a brand-level view hides. Gap had a 20%+ return rate on Tops and Outerwear, but the lowest return rate of any brand in Accessories (1.89%) — a category-specific answer, not a brand-wide one.

### Query 6 — Executive Summary
<img width="1542" height="51" alt="6  Executive Summary" src="https://github.com/user-attachments/assets/5d2a3758-0ece-4e6a-b1cf-ab58b9181abb" />

The one-glance rollup: 2,176 transactions, ₹186,047 total revenue, a 14.71% overall return rate, Zara as the top-revenue brand, and Outerwear confirmed as both the top revenue category and the highest-return category (16.17%) company-wide.


---

## Key Findings — and why they matter to a business
 
**1. Outerwear is simultaneously the biggest revenue driver and the biggest return risk -**
Outerwear was the top-revenue category in every single season — Fall, Spring, Summer, and Winter — making it the most consistent, season-proof performer in the catalog. But it's also the highest-return category company-wide at 16.17%. That's a real strategic tension: the one category the business can't afford to deprioritize is also the one bleeding the most margin back out through returns. Spotting this required connecting the seasonal-trends query with the return-rate query — no single query shows it alone.
 
**2. Return rate of 14.71% — above the healthy retail benchmark (typically 8–10%) -**
A return rate this high directly erodes margin on every affected sale — restocking, shipping, and lost-sale costs stack up fast. Ten specific brand-category combinations were flagged "High Risk." Still, dollar impact matters more than percentage alone: Ann Taylor–Outerwear had the largest revenue actually lost to returns (₹1,535.57) of any flagged combination, even though its percentage (23.4%) wasn't the highest on the list.
 
**3. Gap is discounting hardest while earning the least -**
Across all eight brands, Gap had the lowest total revenue (₹22,261) but the highest average discount (14.12%) and the highest margin erosion (14.71%) — a pricing-discipline problem worth flagging to merchandising rather than just "low performer." By contrast, Uniqlo achieved strong revenue (₹26,192) with the lowest discount rate of any brand (8.92%), showing the two aren't inherently linked.
 
**4. Markdown/clearance pricing isn't solving the underlying problem -**
Products moved into clearance showed no improvement in ratings or return rates compared to full-price items — discounting these products isn't fixing whatever is actually wrong with them; it's just selling the same problem at a lower margin.
 
**5. High-rated, low-stock items flagged for priority reorder -**
Every zero-stock product was checked against its customer rating before being flagged: items rated 4.1★ and above were tagged "Priority Reorder," while lower-rated out-of-stock items were deliberately left unflagged. This turns a simple stockout list into a prioritized action list — restocking proven bestsellers is close to risk-free revenue, unlike reinvesting in items that weren't performing even before they sold out.
 
**6. A brand's problem is often category-specific, not brand-wide -**
Ranking brands within each category (rather than as a single blended average) shows that performance can flip entirely depending on the category. Gap, for example, had a return rate over 20% in Tops and Outerwear, but the *lowest* return rate of any brand in Accessories (1.89%). A single "Gap is high-risk" conclusion would be wrong — the real pattern is category-specific.
 
**7. Hidden data quality issue caught before it could mislead analysis -**
89 records in the Size column contained empty-string values disguised as valid data rather than proper NULLs — the kind of issue that silently skews an analysis if it isn't caught, since it doesn't throw an error; it just quietly produces wrong numbers. Catching and standardizing this before analysis is what separates a trustworthy report from one that looks fine but is subtly wrong.

---

## Files
| File | Description |
|---|---|
| `boutique_sales.csv` | Raw dataset |
| `fashion_boutique_analysis.sql` | Complete project — staging layer, data cleaning, and all 6 analysis queries |

---

## Note on Workflow
Took the help of Claude and Gemini to frame business questions and accelerate debugging. All queries were written, tested, and debugged independently in MySQL Workbench.
