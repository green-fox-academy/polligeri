/*
Feladat #3:
Haszn�ld a WideWorldImporters p�lda adatb�zist!

�rj egy lek�rdez�st ami visszaadja a rendel�si sort�tel (Sales.OrderLines) statisztik�kat a fekete �s a feh�r sz�n� StockItem-ekre!

Az al�bbi t�bl�kat haszn�ld:

Sales.OrderLines
Warehouse.StockItems
Warehouse.Colors
A lek�rdez�s az al�bbi oszlopokkal t�rjen vissza:

[stock_item]: StockItemName oszlop a Warehouse.StockItems t�bl�b�l
[brand]: Brand oszlop a Warehouse.StockItems t�bl�b�l ha a Brand nem ismert akkor �rja ki hogy 'N/A'
[total_order_quantity]: �sszegzett Quantity �rt�k StockItem-enk�nt a Sales.OrderLines t�bla alapj�n
[cnt_orderlines]: h�ny darab Sales.OrderLines t�tel van StockItem-enk�nt
[avg_linetotal]: �tlagos linetotal (Quantity * UnitPrice) StockItem-enk�nt '$' form�tumban
[latest_pickdate_day]: legutols� PickingCompletedWhen oszlop �rt�k StockItem-enk�nt. Csak a nap �rt�k kell, a k�vetkez� form�tumban: 'Latest pickdate day was: ' �s a nap.
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