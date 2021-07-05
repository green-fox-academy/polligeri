/*
Exercise #4
Create a report of Orders their SUM aggregated Line Totals (Unitprice * Quantity).
First declare a variable that holds an integer CustomerID value 
and set a value to it.
Return the Orders and SUM aggregate the Line Totals per each OrderID only 
for the Customer who placed the Orders. 
The Customer is passed as a filter parameter to the query.
If the SUM aggregated Line Total is greater than 1000, 
calculate a 10% discount in a separate column.
Use the following tables:
•	Sales.Orders
•	Sales.OrderLines
Order the report in [Order ID] descending order.

The report should display the following columns:
•	[Order ID]: OrderID column from the Sales.Orders table
•	[Line Total] : the SUM aggregated Line Total 
(Unitprice * Quantity) from the Sales.OrderLines table
•	[Discount Line Total] : the SUM aggregated Line Total 
(Unitprice * Quantity) from the Sales.OrderLines table 
if the Line Total is greater than 1000 calculate a 10% discount 
otherwise write the Line Total

*/

SELECT o.OrderID AS [Order ID], SUM([UnitPrice]*[Quantity]) AS [ Line Total],
CASE
WHEN SUM([UnitPrice]*[Quantity]) > 1000 THEN (SUM([UnitPrice]*[Quantity]))*0.9
ELSE SUM([UnitPrice]*[Quantity])
END AS [Discount Line Total]
FROM Sales.Orders o
JOIN Sales.OrderLines ol
ON o.[OrderID] = ol.[OrderID]
WHERE [PickedByPersonID] IS NOT NULL
GROUP BY o.OrderID
ORDER BY o.OrderID DESC;



