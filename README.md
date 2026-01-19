# FinVerse-Banking-Operations-Risk-Analytics
End-to-End Data Engineering and Business Intelligence Pipeline

📌 Project Overview

FinVerse is a comprehensive data engineering and analytics project designed to transform fragmented, "dark" retail banking data into actionable business intelligence. The project addresses critical banking challenges including data integrity issues, lack of branch-level performance visibility, and the need for automated risk identification

By implementing a structured Star Schema RDBMS, this pipeline ensures 100% data integrity while providing a scalable framework for proactive risk management.

🛠️ Tech Stack

Data Cleaning & Engineering: Python (Pandas, NumPy) 


Database Management: PostgreSQL / SQL 


Business Intelligence: Power BI 

Environment: GitHub for Version Control

🚀 Key Features & Methodology
1. Data Engineering Pipeline (Python)

Automated Cleaning: Standardized date formats and handled missing values across five datasets (Accounts, Customers, Loans, Transactions, and Branches).

Statistical Imputation: Used Median Imputation for critical fields like OpeningDate to maintain distribution accuracy.

Feature Engineering: * Customer Segmentation: Categorized customers into 'Minor', 'Young Adult', 'Adult', and 'Senior' groups.

Outlier Detection: Flagged account balances exceeding two standard deviations from the mean.

Loan Categorization: Automated classification of loans into Small, Medium, and Large categories based on principal amounts.

<img width="698" height="482" alt="Screenshot 2026-01-18 224335" src="https://github.com/user-attachments/assets/6bfb0c2e-9d9d-43c8-b367-1411fcfd5f02" />

2. Analytical Pipeline (SQL)

Database Schema: Designed a robust relational schema with primary and foreign key constraints to ensure referential integrity.

Advanced Analytics:

Risk Management: Developed a Debt-to-Equity scoring system to identify high-leverage customers before potential defaults.

Performance Metrics: Ranked banking zones based on their contribution to total bank revenue using Window Functions.

<img width="912" height="651" alt="Screenshot 2026-01-18 215231" src="https://github.com/user-attachments/assets/c7bcb0af-bfe3-4b44-8e9f-c33029b431dc" />

3. Business Intelligence (Power BI)

Interactive Strategic Dashboard: Developed a visual interface for management to track banking performance and risk metrics in real-time.


Operational Insights: Automated reporting to allow branch managers to focus on high-value zones and critical loan portfolios

<img width="1379" height="831" alt="Screenshot 2026-01-18 225954" src="https://github.com/user-attachments/assets/20be04c9-6cb5-4c61-8cad-c07bb0f7152e" />

📊 Business Wins

Data Integrity: Achieved 100% integrity through structured data transformation.

Default Reduction: Established early warning systems for high-risk account.

Scalability: Created a Python/SQL framework capable of handling increased transaction volumes without manual overhead.


📂 Repository Structure

clean_data.py: Python script for ETL processes and feature engineering.

sql_query.sql: SQL scripts for schema creation and advanced business analytics.

data/: Directory containing cleaned CSV files (accounts.csv, customers.csv, etc.).

dashboard.pbix: Power BI dashboard file.

presentation.pptx: Detailed project walkthrough and visual results.

👤 Author

Arpita Parmar M 


LinkedIn:https://www.linkedin.com/in/arpita-parmar-b70476348/

Email: arpitaparmar548@gmail.com
