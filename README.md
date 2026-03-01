# 📦 Superstore Sales Analysis — SQL

A project focusing on analyzing a US retail dataset using pure SQL. 

## 🎯 The Goal
The repository simulates a real-world scenario where the business team sends questions and the analyst answers them using data. No fancy dashboards here—just solid, optimized queries to solve business problems.

## 📊 Dataset
We’re using the **Sample Superstore** dataset (2014–2017), which contains about 10,000 retail orders.

* **📥 Data Source:** [Kaggle - Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

### Main Columns:
| Column | Description |
| :--- | :--- |
| `Order Date` | When the order was placed |
| `Segment` | Consumer, Corporate, or Home Office |
| `Region` | East, West, Central, and South |
| `Category` | Product category |
| `Sales` | Total transaction value |
| `Profit` | Final profit |

---

## 🧠 Business Questions Answered

### 🗺️ General Performance
* Total revenue and profit metrics.
* Best performing regions.
* Profitability by customer segment.

### 📦 Product Insights
* Top-selling categories and sub-categories.
* Identifying products that are actually losing money.
* Analyzing if high discounts are hurting the bottom line.

### 👥 Customer Behavior
* Top 10 customers by revenue.
* Loyalty check: Customers with more than 3 separate purchases.

### 📅 Time Series
* Monthly revenue trends.
* Year-over-Year (YoY) growth analysis.

---

## 🛠️ SQL Toolbox
What I used to get the job done:
* **Basics:** `GROUP BY`, `HAVING`, `WHERE`, `ORDER BY`.
* **Aggregations:** `SUM`, `AVG`, `COUNT`.
* **Logic:** `CASE WHEN` for conditional formatting.
* **Advanced:** `WITH (CTEs)` and Window Functions like `LAG()` and `RANK()`.

---
*Open to feedback! Feel free to reach out if you have questions about the logic used in the queries.*
