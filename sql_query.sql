-- 1. Create Customer Types Table
CREATE TABLE customer_types (
    CustomerTypeID INT PRIMARY KEY,
    TypeName VARCHAR(50)
);

-- 2. Create Branches Table
CREATE TABLE branches (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    AddressID INT,
    Zone VARCHAR(50),
    BranchRating NUMERIC(3,1)
);

-- 3. Create Customers Table
CREATE TABLE customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    DateOfBirth TIMESTAMP,
    AddressID INT,
    CustomerTypeID INT,
    FullName VARCHAR(200),
    Age INT,
    Age_Group VARCHAR(50),
    CONSTRAINT fk_customer_type FOREIGN KEY (CustomerTypeID) REFERENCES customer_types(CustomerTypeID)
);

-- 4. Create Accounts Table
CREATE TABLE accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    AccountTypeID INT,
    AccountStatusID INT,
    Balance NUMERIC(15,2),
    OpeningDate DATE,
    Age_days INT,
    Is_Outlier_Balance INT,
    Balance_category VARCHAR(50),
    CONSTRAINT fk_customer FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);

-- 5. Create Transaction Types Table
CREATE TABLE transaction_types (
    TransactionTypeID INT PRIMARY KEY,
    TypeName VARCHAR(50)
);

-- 6. Create Transactions Table
CREATE TABLE transactions (
    TransactionID INT PRIMARY KEY,
    AccountOriginID INT,
    AccountDestinationID INT,
    TransactionTypeID INT,
    Amount NUMERIC(15,2),
    TransactionDate TIMESTAMP,
    BranchID INT,
    Description TEXT,
    Year INT,
    Month INT,
    Day INT,
    Hour INT,
    AmountCategory VARCHAR(50),
    CONSTRAINT fk_origin_account FOREIGN KEY (AccountOriginID) REFERENCES accounts(AccountID),
    CONSTRAINT fk_dest_account FOREIGN KEY (AccountDestinationID) REFERENCES accounts(AccountID),
    CONSTRAINT fk_trans_type FOREIGN KEY (TransactionTypeID) REFERENCES transaction_types(TransactionTypeID),
    CONSTRAINT fk_branch FOREIGN KEY (BranchID) REFERENCES branches(BranchID)
);

-- 7. Create Loans Table
CREATE TABLE loans (
    LoanID INT PRIMARY KEY,
    AccountID INT,
    LoanStatusID INT,
    PrincipalAmount NUMERIC(15,2),
    InterestRate NUMERIC(5,4),
    StartDate TIMESTAMP,
    EstimatedEndDate TIMESTAMP,
    Long_term_age INT,
    interest_amount NUMERIC(15,2),
    loan_category VARCHAR(50),
    CONSTRAINT fk_loan_account FOREIGN KEY (AccountID) REFERENCES accounts(AccountID)
);

TRUNCATE TABLE customers RESTART IDENTITY CASCADE;


select *from accounts;
select *from branches;
select *from customer_types;
select *from customers;
select *from loans;
select *from transaction_types;
select *from transactions;


--Customer Demographics Analysis: 
--How many customers does the bank have in each Age_Group (e.g., Adult, Senior, Young Adult), and which group is the largest?

select count(*) as count_group,age_group from customers
group by age_group
order by count_group desc
limit 1

--Account Overview: What is the total and average Balance across all bank accounts?
select sum(balance), round(avg(balance),2),count(accountid)
from accounts

--Branch Directory: List all BranchNames along with their BrancRating and the Zone they belong to, sorted by rating.
select branchname,branchrating,zone
from branches
order by branchrating

--Customer Type Value: Which TypeName (Individual, Small Business, or Large Enterprise)
--contributes the most to the bank's total deposits (sum of Balance)?
select sum(a.balance) as total_balance,ct.typename
from accounts a
join customers c
on a.customerid=c.customerid
join customer_types ct
on c.customertypeid=ct.customertypeid
group by ct.typename
order by total_balance desc

--Loan Portfolio Breakdown: For each loan_category (Small, Medium, Large), 
--what is the total PrincipalAmount issued and the average InterestRate?

select sum(principalamount) as total_issues_amount,round(avg(InterestRate),2),loan_category,count(loanid)
from loans
group by loan_category
order by total_issues_amount desc

--High-Traffic Branches:
--Identify the top 5 branches based on the total volume (count) and total Amount of transactions they have processed.


select count(b.branchid),sum(t.amount) as total,branchname
from branches as b
join transactions as t
on b.branchid=t.branchid
group by b.branchid,b.branchname
order by total desc
limit 5

--Revenue & Growth Trends: Calculate the monthly trend of transaction totals for the year 2023. 
--Are there specific months where the bank sees a significant spike in activity?

select  month,sum(amount) as total,count(TransactionID)
from transactions
where year=2023
group by month
order by total desc

--Cross-Product Risk Assessment: Identify "High-Risk" customers who have "Large" 
--category loans but maintain a "Low" Balance_category in their savings/checking accounts.

select a.accountid,c.fullname,l.PrincipalAmount, 
    l.loan_category, 
    a.Balance, 
    a.Balance_category
from accounts as a
join loans as l
on a.accountid=l.accountid
join customers as c
on c.customerid=a.customerid
where l.loan_category='Large' and a.Balance_category='Low'

---Rank each zone based on its contribution to total transaction volume compared to the bank's overall performance. 
--This uses a CTE to aggregate data and a Window Function to calculate the percentage contribution and final rank.

with zonelrevenue as(
select b.zone,sum(t.amount) as Total_Zone_Turnover,count(t.TransactionID) as Transaction_Count
from branches as b
join transactions  as t 
on b.branchid=t.branchid
group by b.zone
)
select zone,round((Total_Zone_Turnover/sum(Total_Zone_Turnover) over()) *100,2)AS Pct_of_Total_Bank_Revenue,Total_Zone_Turnover,
rank() over(order by Total_Zone_Turnover desc) AS Performance_Rank
from zonelrevenue

--High-Leverage Customer Identification (Debt-to-Equity)
--Objective: Identify the most "leveraged" customers (those with the highest debt relative to their savings) 
--and rank them within their specific Age_Group. This uses a CTE to join multiple tables and DENSE_RANK() to categorize the risk.


with cte as(select c.customerid,c.fullname,c.age_group,sum(COALESCE(l.principalamount,0)) as total_debt,sum(COALESCE(a.balance,0)) as total_saving
from accounts a
join loans l
on a.accountid=l.accountid
join customers c
on a.customerid=c.customerid
group by 1,2,3)

select customerid,fullname,age_group,round(total_debt / nullif(total_saving,0),2) Debt_to_Equity_Ratio,
DENSE_RANK()over(partition by age_group order by (total_debt / nullif(total_saving,0))desc)  AS Risk_Rank_In_Group
from cte
where total_debt>0;