import pandas as pd
import numpy as np

df=pd.read_csv("F:/data_analisyt_project/project_2/accounts.csv")


df=df.drop_duplicates()
df['OpeningDate']=pd.to_datetime(df['OpeningDate'])
meadian_date=df['OpeningDate'].median()
df['OpeningDate']=df['OpeningDate'].fillna(meadian_date)

current_date=pd.to_datetime('2026-08-01')
df['Age_days']=(current_date-df['OpeningDate']).dt.days

mean_balance=df['Balance'].mean()
std_balance=df['Balance'].std()

df['Is_Outlier_Balance']=np.where(df['Balance']>=(mean_balance + 2 * std_balance),1,0)
df['Balance_category']=pd.qcut(df['Age_days'], q=3 , labels=['Low', 'Medium', 'High'])

df.to_csv("F:/data_analisyt_project/project_2/accounts.csv",index=False)
print(df.head(10))



df=pd.read_csv("F:/data_analisyt_project/project_2/branches.csv")
df=df.drop_duplicates()
df['BranchName']=df['BranchName'].str.upper()

condition=(df['AddressID']< 400),(df['AddressID']>=400) & (df['AddressID'] <= 800),(df['AddressID']>800)
choice=['Zone1','Zone2','Zone3']
df['Zone'] = np.select(condition, choice, default='Other')

np.random.seed(43)   #With a seed: Every time you run the code, the ratings are identical.
df['BrancRating']=np.round(np.random.uniform(1.0,5.0,size=len(df)), 1)
print(df.head(10))

df.to_csv("F:/data_analisyt_project/project_2/branches.csv",index=False)


df=pd.read_csv("F:/data_analisyt_project/project_2/customers.csv")

df['DateOfBirth']=pd.to_datetime(df['DateOfBirth'],errors='coerce')
df['FirstName']=df['FirstName'].fillna('Unknow').str.strip()
df['LastName']=df['LastName'].fillna('unknow').str.strip()

df = df.drop_duplicates(subset=['CustomerID'])

df['FullName']=df['FirstName']+' '+df['LastName']

df['Age']=(pd.Timestamp('2026-01-08')-df['DateOfBirth']).dt.days // 365

meadian_type=df['Age'].median()
df['Age']=df['Age'].apply(lambda x: x if (not np.isnan(x) and x>=0) else meadian_type)
df['Age']=df['Age'].astype(int)

condition=[(df['Age']<18),(df['Age']>=18) & (df['Age']<=35),(df['Age']>=35) & (df['Age']<=60),(df['Age']>=60)]

choice=['Minor', 'Young Adult', 'Adult', 'Senior']
df['Age_Group']=np.select(condition,choice,default='Unknown')
print(df.info())
print(df.head(10))
df.to_csv("F:/data_analisyt_project/project_2/customers.csv",index=False)



df=pd.read_csv("F:/data_analisyt_project/project_2/loans.csv")

df['StartDate']=pd.to_datetime(df['StartDate'],errors='coerce')
df['EstimatedEndDate']=pd.to_datetime(df['EstimatedEndDate'],errors='coerce')

df=df.dropna(subset=['StartDate', 'EstimatedEndDate'])
df = df.drop_duplicates(subset=['LoanID'])

df['Long_term_age']=(df['EstimatedEndDate']-df['StartDate']).dt.days
df['interest_amount']=(df['PrincipalAmount']*df['InterestRate']).round(2)

meadian_term=df.loc[df['Long_term_age']>=0,'Long_term_age'].median()#it mean it calculate only meadian value which have positive number nagative ignore it
df['Long_term_age']=df['Long_term_age'].apply(lambda x:x if x>=0 else meadian_term)

condition=[(df['PrincipalAmount']<1000),
           (df['PrincipalAmount']>=1000)&
           (df['PrincipalAmount']<5000),
           (df['PrincipalAmount']>=5000)]

choice=['Small', 'Medium', 'Large']
df['loan_category']=np.select(condition,choice,default='Unkonw')
print(df.head(10))
print(df.info())
df.to_csv("F:/data_analisyt_project/project_2/loans.csv",index=False)


df=pd.read_csv("F:/data_analisyt_project/project_2/transactions.csv")

df=df.drop_duplicates().reset_index(drop=True)

df['TransactionDate']=pd.to_datetime(df['TransactionDate'],errors='coerce')
df=df.dropna(subset=['TransactionDate'])

df['Year']=df['TransactionDate'].dt.year
df['Month']=df['TransactionDate'].dt.month
df['Day']=df['TransactionDate'].dt.day
df['Hour'] = df['TransactionDate'].dt.hour

bins=[0,1000,3000,np.inf]
labels=['Small', 'Medium', 'Large']
df['AmountCategory']=pd.cut(df['Amount'],bins=bins,labels=labels)


branch_summary=df.groupby('BranchID').agg(
    TotalAmount=('Amount','sum'),
    TransactionCount=('TransactionID','count')
).reset_index().sort_values('TotalAmount',ascending=False)

print(df.info())
print(df.head(10))
print(branch_summary)


df.to_csv("F:/data_analisyt_project/project_2/transactions.csv",index=False)
