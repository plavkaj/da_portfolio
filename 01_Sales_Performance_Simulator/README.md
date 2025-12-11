Project: Sales Performance & Commission Simulator

### Project Overview
**Role:** Commercial Planning Analyst (Simulation)  
**Tools:** SQL (ETL & Logic), Power BI (Visualization), DAX  
**Goal:** Transform raw retail transaction data into an interactive dashboard to monitor sales performance and simulate a new commission structure for the sales team.

![Dashboard Preview](dashboard_screenshot.png)
*(Note: This dashboard visualizes the finalized commission logic and sales trends)*

---

### Business Problem
A UK-based online retailer wants to:
1.  **Track Sales Performance:** Move from static Excel sheets to dynamic monitoring of revenue and trends.
2.  **Identify Key Markets:** Understand which countries (outside the domestic UK market) are driving growth.
3.  **Simulate Remuneration:** The management proposed a new bonus scheme: **5% commission on a fixed 30% margin**. They needed to know the financial impact of this logic before implementation.

### Solution Architecture
I implemented a full-stack data analysis workflow:

**1. Data Cleaning & ETL (SQL)**
* **Raw Data:** ~1 million rows of transaction data (2009-2011).
* **Cleaning:** Used SQL to remove cancellations (Invoices starting with 'C'), negative quantities, and "anonymous" transactions (missing Customer IDs).
* **Transformation:** Cast text fields to correct data types (`DATETIME`, `DECIMAL`) and created a standardized schema using a Staging vs. Production table strategy.
* *Key Skill:* Handling dirty data and ensuring data integrity before analysis.

**2. Business Logic Implementation (DAX)**
Instead of pre-calculating everything in Excel, I used DAX measures to make the dashboard interactive:
* `Total Revenue` = `SUM(Revenue)`
* `Estimated Margin` = `[Total Revenue] * 0.30` (Assumption based on business brief)
* `Commission Bonus` = `[Estimated Margin] * 0.05`

**3. Visualization & Reporting (Power BI)**
* **Strategic Layout:** KPIs at the top follow the P&L logic (Revenue -> Margin -> Bonus).
* **Market Analysis:** Created a specific breakdown for **International Markets (Excl. UK)** to reveal export opportunities, identifying EIRE and Netherlands as top performers.
* **Trend Analysis:** Drilled down to monthly views to reveal the Q4 seasonal peak.

---

### Key Findings
1.  **Revenue & Seasonality:** Total analyzed revenue stands at **£17.7M**. There is a distinct seasonal trend with sales peaking significantly in **Q4 (September - December)**, suggesting the need for increased inventory and staffing during this period.
2.  **International Growth:** While the UK is the primary market, **EIRE (Ireland)** and the **Netherlands** are the strongest export territories. Future marketing spend should target these regions to maximize ROI.
3.  **Commission Impact:** Under the proposed 5% scheme, the total payout would be approx. **£266k** (approx 1.5% of total revenue). This confirms the scheme is financially sustainable for the company.

---

### Repository Structure

* **`SQL_Scripts/`**
  * `01_Data_Cleaning.sql` - The ETL script for cleaning raw data, handling data types, and removing cancellations.
* **`PBI_Reports/`**
  * `Sales_Performance_Dashboard.pbix` - The interactive Power BI dashboard source file.
  * `Sales_Report.pdf` - A static print-ready version of the report.
* **`README.md`** - Project documentation.
* `Dashboard_Final.png` - Visual preview of the report.

---

### Data Source & Credits
**Dataset:** Online Retail II UCI  
**Source:** Kaggle (originally from UCI Machine Learning Repository)  
**Link:** [https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci)  
**License:** CC0: Public Domain


