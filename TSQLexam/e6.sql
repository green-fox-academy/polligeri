/*
Exercise #6:
Create a view with schemabinding in the Sales schema named CustomerCategoryCredit.
Return the Customers and their associated Categories along 
with their verbose Credit Limits.
Use the following tables:
•	Sales.Customers
•	Sales.CustomerCategories
The report should display the following columns:
•	[Customer Name] : Customer Name from Sales.Customers
•	[Customer Category]: CustomerCategoryName column from Sales.CustomerCategories
•	[Credit Limit]: CreditLimit column from Sales.Customers
o	Write 'N/A' if CreditLimit is missing
o	Write 'Greater than 3000' if CreditLimit is greater than 3000
o	Write 'Between 1500 and 3000' if CreditLimit is between 1500 and 3000
o	Write 'Less than 1500' if CreditLimit is less than 1500
•	[Current Datetime]: current date and time of running the report
Showcase how you use the view in a query!

*/

DROP VIEW IF EXISTS Sales.CustomerCategoryCredit;
GO
CREATE VIEW Sales.CustomerCategoryCredit
WITH SCHEMABINDING
AS
  SELECT [CustomerName] as [Customer Name], 
  CustomerCategoryName as [Customer Category],
  CASE   
			WHEN CreditLimit IS NULL               THEN 'N/A'
            WHEN CreditLimit > 3000                THEN 'Greater than 3000'
            WHEN CreditLimit BETWEEN 1500 AND 3000 THEN 'Between 1500 and 3000'
            WHEN CreditLimit < 1500                THEN 'Less than 1500' 
         ELSE 'Over $1000'  
      END as [Credit Limit],
	GETDATE() as [Current Datetime]
  FROM Sales.Customers c INNER JOIN Sales.CustomerCategories cc
  ON c.[CustomerCategoryID] = cc.[CustomerCategoryID];
GO

SELECT * FROM Sales.CustomerCategoryCredit;