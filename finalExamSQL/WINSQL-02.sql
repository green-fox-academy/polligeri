USE [WideWorldImporters]
GO

SELECT
   [Sales].[Customers].[CustomerID]        AS [customer_id],
   MAX([Sales].[Customers].[CustomerName]) AS [customer_name],  -- MAX azért mert aggregálni ( a lenti group by miatt) kell a mezõket, 
   MAX([Sales].[Customers].[CreditLimit])  AS [credit_limit]    -- de mivelhogy minden customerid hoz 1 name / limit tartozhat ezért elég a max
FROM [Sales].[Customers]

INNER JOIN [Sales].[CustomerTransactions] AS [a]
    ON  [a].[CustomerID]      = [Sales].[Customers].[CustomerID]
    AND [a].[TransactionDate] BETWEEN '2015-01-01' AND '2015-12-31'

INNER JOIN [Sales].[CustomerTransactions] AS [b]
    ON  [b].[CustomerID]      = [Sales].[Customers].[CustomerID]
    AND [b].[TransactionDate] NOT BETWEEN '2014-01-01' AND '2014-12-31'

WHERE [Sales].[Customers].[CreditLimit] IS NOT NULL
GROUP BY [Sales].[Customers].[CustomerID]
ORDER BY [Sales].[Customers].[CustomerID] DESC