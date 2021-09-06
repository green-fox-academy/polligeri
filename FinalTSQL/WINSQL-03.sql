/*
Feladat #3:
Használd a WideWorldImporters példa adatbázist!

Írj egy lekérdezést ami visszaadja a rendelési sortétel (Sales.OrderLines) statisztikákat a fekete és a fehér színû StockItem-ekre!

Az alábbi táblákat használd:

Sales.OrderLines
Warehouse.StockItems
Warehouse.Colors
A lekérdezés az alábbi oszlopokkal térjen vissza:

[stock_item]: StockItemName oszlop a Warehouse.StockItems táblából
[brand]: Brand oszlop a Warehouse.StockItems táblából ha a Brand nem ismert akkor írja ki hogy 'N/A'
[total_order_quantity]: összegzett Quantity érték StockItem-enként a Sales.OrderLines tábla alapján
[cnt_orderlines]: hány darab Sales.OrderLines tétel van StockItem-enként
[avg_linetotal]: átlagos linetotal (Quantity * UnitPrice) StockItem-enként '$' formátumban
[latest_pickdate_day]: legutolsó PickingCompletedWhen oszlop érték StockItem-enként. Csak a nap érték kell, a következõ formátumban: 'Latest pickdate day was: ' és a nap.
*/
USE [WideWorldImporters];
GO
SELECT
   MAX([WideWorldImporters].[Warehouse].[StockItems].[StockItemName])         AS [stock_item],
   ISNULL(MAX([WideWorldImporters].[Warehouse].[StockItems].[Brand]), 'N/A')  AS [brand],
   SUM([WideWorldImporters].[Sales].[OrderLines].[Quantity])                  AS [total_order_quantity],
   COUNT(*)                                                                   AS [cnt_orderlines],
   FORMAT(
       AVG([WideWorldImporters].[Sales].[OrderLines].[Quantity] * [WideWorldImporters].[Sales].[OrderLines].[UnitPrice]),
       'C'
   )                                                                          AS [avg_linetotal],
   CONCAT(
       'Latest pickdate day was: ',
       FORMAT(MAX([WideWorldImporters].[Sales].[OrderLines].[PickingCompletedWhen]), 'dd')
   )                                                                          AS [latest_pickdate_day]
FROM [WideWorldImporters].[Sales].[OrderLines]

LEFT JOIN [WideWorldImporters].[Warehouse].[StockItems] ON
    [WideWorldImporters].[Warehouse].[StockItems].[StockItemID] = [WideWorldImporters].[Sales].[OrderLines].[StockItemID]

LEFT JOIN [WideWorldImporters].[Warehouse].[Colors] ON
    [WideWorldImporters].[Warehouse].[Colors].[ColorID] = [WideWorldImporters].[Warehouse].[StockItems].[ColorID]

WHERE [WideWorldImporters].[Warehouse].[Colors].[ColorName] IN ('Black', 'White')

GROUP BY [WideWorldImporters].[Sales].[OrderLines].[StockItemID]