USE WideWorldImporters
GO

SELECT
    MAX([Sales].[Customers].[CustomerID])   AS [Customer ID],
    MAX([Sales].[Customers].[CustomerName]) AS [Customer Name],
    MAX([Sales].[Customers].[CreditLimit])  AS [Credit Limit]
FROM [Sales].[Customers]

LEFT JOIN [Sales].[Orders]
    ON  [Sales].[Orders].[CustomerID] = [Sales].[Customers].[CustomerID]
    AND [Sales].[Orders].[OrderDate]  BETWEEN '2016-05-01' AND '2016-05-15'

GROUP BY [Sales].[Customers].[CustomerID]
HAVING COUNT([Sales].[Orders].OrderID) = 0

GO