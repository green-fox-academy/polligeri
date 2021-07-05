/*
Exercise #7:
Create an inline table-valued function in the Sales schema named StockGroupReport.
It should use two parameters:
•	@stockgroupname of nvarchar(100), with a default value of 'Toys'
•	@pricelimit of decimal(18,2), with a default value of 3000.00
Return the stock group and its associated stock items based on the parameter value.
Use the following tables:
•	Warehouse.StockGroups
•	Warehouse.StockItemStockGroups
•	Warehouse.StockItems
The report should display the following columns:
•	[Stock Group Name]: StockGroupName column from Warehouse.StockGroups
•	[Stock Item Name] : StockItemName column from Warehouse.StockItems
•	[Marketing Comments]: MarketingComments column from Warehouse.StockItems If the column value is NULL, display 'N/A', otherwise display the column value
•	[Retail Price]: RecommendedRetailPrice column from Warehouse.StockItems
•	[Percent of Price Limit]: the [Retail Price] percentage compared to the @pricelimit parameter Display the percentage value with a precision of 2 digits
Showcase how you use the table-valued function!
*/

DROP FUNCTION IF EXISTS Sales.StockGroupReport;
GO
CREATE FUNCTION Sales.StockGroupReport(
    @stockgroupname nvarchar(100) = 'Toys',
    @pricelimit     decimal(18,2) = 3000.00
) RETURNS TABLE
AS
RETURN(
    SELECT
        StockGroupName AS 'Stock Group Name',
        StockItemName AS 'Stock Item Name',
        ISNULL(MarketingComments, 'N/A') AS 'Marketing Comment',
        RecommendedRetailPrice AS 'Retail Price',
        CAST(RecommendedRetailPrice / @pricelimit * 100 AS DECIMAL(18,2)) AS 'Percent of Price Limit'
    FROM Warehouse.StockGroups

    INNER JOIN Warehouse.StockItems
        ON Warehouse.StockItems.[StockItemID] = Warehouse.StockGroups.[StockGroupID]

    WHERE Warehouse.StockGroups.StockGroupName = @stockgroupname
)
GO

SELECT * FROM Sales.StockGroupReport ('Hello', 1234.00);