USE WideWorldImporters
GO

DROP PROCEDURE IF EXISTS [Sales].[GetPickedByDate];
GO
CREATE PROCEDURE [Sales].[GetPickedByDate]
    @startDate datetime = '2013-01-01',
    @endDate   datetime = '2016-06-01'
AS BEGIN
    SET NOCOUNT OFF
    SELECT
        MAX([Sales].[Customers].[CustomerName])                                                           AS [Customer Name],
        ISNULL(MAX([Sales].[Orders].[PickingCompletedWhen]), DATEADD(DAY, 3, SYSDATETIME()))              AS [Pick Date],
        ROUND(SUM([Sales].[OrderLines].[Quantity] * [Sales].[OrderLines].[UnitPrice]), 2)                 AS [Overall Price],
        COUNT(*)                                                                                          AS [Number of Purchase], 
           
        IIF(MAX([Sales].[Orders].[PickingCompletedWhen]) IS NULL, 'Expected Pick Date', 'Already picked') AS [Refreshed Date]
    FROM [Sales].[Customers]

    INNER JOIN [Sales].[Orders]
        ON  [Sales].[Orders].[CustomerID] = [Sales].[Customers].[CustomerID]
        AND [Sales].[Orders].[OrderDate]  BETWEEN @startDate AND @endDate

    INNER JOIN [Sales].[OrderLines]
        ON  [Sales].[OrderLines].[OrderID] = [Sales].[Orders].[OrderID]

    WHERE [Sales].[Customers].[BuyingGroupID] IS NULL

    GROUP BY [Sales].[Orders].[OrderID]

    HAVING SUM([Sales].[OrderLines].[Quantity] * [Sales].[OrderLines].[UnitPrice]) > 20000
END
GO

EXEC [Sales].[GetPickedByDate] '2014-01-01', '2015-01-01'
GO
