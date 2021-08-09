USE WideWorldImporters
GO

DROP PROCEDURE IF EXISTS hello;
GO
CREATE PROCEDURE hello
    @color nvarchar(20) = 'Black'
AS BEGIN
    SET NOCOUNT OFF
    SELECT 
        MAX([Warehouse].[StockItems].[StockItemName])                                                            AS [stock item],
        MAX(ISNULL([Warehouse].[StockItems].[Brand], 'N/A'))                                                     AS [brand],
        SUM([Sales].[OrderLines].[Quantity])                                                                     AS [total_order_quantity],
        SUM(IIF(YEAR([Sales].[OrderLines].[PickingCompletedWhen]) = '2016', [Sales].[OrderLines].[Quantity], 0)) AS [2016_picked_quantity],
        STRING_AGG(YEAR([Sales].[OrderLines].[PickingCompletedWhen]), ',')                                       AS [cnt_pick_years],
        COUNT(*)                                                                                                 AS [cnt_orderlines],
        CAST(ROUND(AVG([Sales].[OrderLines].[Quantity] * [Sales].[OrderLines].[UnitPrice]), 0) AS INT)           AS [avg_linetotal],
        FORMAT(MAX([Sales].[OrderLines].[PickingCompletedWhen]), 'yyyy-MM-dd')                                   AS [latest_pickdate]
    FROM [Sales].[OrderLines]

    INNER JOIN [Warehouse].[StockItems]
        ON [Warehouse].[StockItems].[StockItemID] = [Sales].[OrderLines].[StockItemID]

    INNER JOIN [Warehouse].[Colors]
        ON  [Warehouse].[Colors].[ColorID]   = [Warehouse].[StockItems].[ColorID]
        AND [Warehouse].[Colors].[ColorName] = @color

    GROUP BY [Warehouse].[StockItems].[StockItemID]
END
GO

SET NOCOUNT ON
EXEC hello 'White'