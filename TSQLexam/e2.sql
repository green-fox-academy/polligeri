/*
Exercise #2
Create a report of all Colors and the number of Stock Items that each color has. 
Return all Colors regardless how many Stock Items they have. (zero or more)
Not all colors have Stock Items. If a color has no Stock Item, 
display 0 (zero) in [Number of Stock Items].
Order the report by the Number of Stock Items in descending order.
Use the following tables:
•	Warehouse.Colors
•	Warehouse.StockItems
The report should display the following columns:
•	[Color]: ColorName from the Warehouse.Colors table
•	[Number of Stock Items] : the number of Stock Items each color has

*/

SELECT ColorName AS [Color], COUNT([StockItemID]) AS [Number of Stock Items]
FROM [Warehouse].[Colors] AS C
LEFT JOIN [Warehouse].[StockItems] AS S
ON C.[ColorID] = S.ColorID
GROUP BY ColorName
ORDER BY [Number of Stock Items] DESC;