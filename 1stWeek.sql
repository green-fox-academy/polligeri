1.
/* 
    Modify this query so that the GROUP BY and the HAVING clauses also use the [Order ID] column alias.
    What happens? Why?
*/
/*
SELECT OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
HAVING OrderID IN (46, 47, 48)
ORDER BY [Order ID] ASC;
*/

SELECT OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY [Order ID]
HAVING [Order ID] IN (46, 47, 48)
ORDER BY [Order ID] ASC;

ERROR:
Msg 207, Level 16, State 1, Line 18
Invalid column name 'Order ID'.
Msg 207, Level 16, State 1, Line 19
Invalid column name 'Order ID'.
Msg 207, Level 16, State 1, Line 19
Invalid column name 'Order ID'.
Msg 207, Level 16, State 1, Line 19
Invalid column name 'Order ID'.

/*
ANSWER:
Logical Processing Order of the SELECT statement:
FROM
ON
JOIN
WHERE
GROUP BY
WITH CUBE or WITH ROLLUP
HAVING
SELECT
DISTINCT
ORDER BY
TOP
*/

2.
/* 
    Modify this query so that you add a third column in the SELECT list: (Sum_Qty - 10) AS Reduced_Qty
    What happens? Why?

    How would you resolve the problem and add the Reduced_Qty column so that the query works?

    
    | Order ID | Sum_Qty | Reduced_Qty |
    ------------------------------------
    

SELECT OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
HAVING OrderID IN (46, 47, 48)
ORDER BY [Order ID] ASC;
*/

SELECT OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty, (Sum_Qty - 10) AS Reduced_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
HAVING OrderID IN (46, 47, 48)
ORDER BY [Order ID] ASC;

/*
ERROR:
Msg 207, Level 16, State 1, Line 68
Invalid column name 'Sum_Qty'.

ANSWER:
Logical Processing Order of the SELECT statement.
*/

SOLUTION:

SELECT OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty, (Quantity - 10) AS Reduced_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID, Quantity
HAVING OrderID IN (46, 47, 48)
ORDER BY [Order ID] ASC;

3.
/* 
    Modify this query so that you alias the Sales.OrderLines table.
    Then qualify the column names in the SELECT list with the table alias.

SELECT OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
HAVING OrderID IN (46, 47, 48)
ORDER BY [Order ID] ASC;
*/

SELECT sol.OrderID AS [Order ID], SUM(sol.Quantity) AS Sum_Qty
FROM Sales.OrderLines AS sol
WHERE UnitPrice > 10
GROUP BY OrderID
HAVING OrderID IN (46, 47, 48)
ORDER BY [Order ID] ASC;

4.
/*
    a,Remove the TOP 10 filter and see how many rows are returned.
    b,Apply a TOP ten percent filter instead and see how many rows are returned.
    c,Try different filter and percent values.

SELECT TOP 10 OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
ORDER BY [Order ID] ASC;
*/
a,
SELECT OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
ORDER BY [Order ID] ASC;

ANSWER:71407 rows

b,
SELECT TOP 10 percent OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
ORDER BY [Order ID] ASC;

ANSWER:7141 rows

c,
SELECT TOP 20 OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
ORDER BY [Order ID] ASC;

SELECT TOP 20 percent OrderID AS [Order ID], SUM(Quantity) AS Sum_Qty
FROM Sales.OrderLines
WHERE UnitPrice > 10
GROUP BY OrderID
ORDER BY [Order ID] ASC;

5.
/*
    a,Run the following query and see the results. What do you see?
    b,Modify the query to use the TOP filter WITH TIES. What happens?
    c,Modify the query to remove duplicates and then return the TOP 10 UnitPrice. What happens?

SELECT TOP 10 UnitPrice
FROM Sales.OrderLines
ORDER BY UnitPrice DESC;
*/
SELECT TOP 10 UnitPrice
FROM Sales.OrderLines
ORDER BY UnitPrice DESC;

a, 
all results are the same.

b,
SELECT TOP 10 WITH TIES UnitPrice
FROM Sales.OrderLines
ORDER BY UnitPrice DESC;

1061 rows, and all results are the same.

c,
SELECT DISTINCT TOP 10 UnitPrice
FROM Sales.OrderLines
ORDER BY UnitPrice DESC;

10 different results.

6.
/*
    Find the table that contains data about cities.
    Write a query that returns the 10 cities with the highest population.
    Alias the city population column as [population].

    | CityID | CityName | population |
    ----------------------------------

*/
SELECT TOP 10 [CityName], MAX([LatestRecordedPopulation]) AS [population] 
FROM [Application].[Cities_Archive]
GROUP BY [CityName];

7.
/* 
    Find the table where there are order dates.
    Write a query that returns the distinct order dates in descending order.
    Alias the returned column as [Order Date].  

    | Order Date |
    --------------

    Try using a different ordering, not on order date. What happens?

*/
SELECT DISTINCT [OrderDate] AS [Order Date]
FROM [Sales].[Orders]
ORDER BY [OrderDate] DESC;

SELECT OrderID, OrderLineID, Description
FROM Sales.OrderLines
ORDER BY OrderID DESC, OrderLineID ASC;

8.
/* 
    Find the table that contains data about cities.
    Write a query that returns the 10 cities with the highest population, but use the paging method.
    Alias the city population column as [population].


    | CityID | CityName | population |
    ----------------------------------

*/
SELECT [CityName], MAX([LatestRecordedPopulation]) AS [population] 
FROM [Application].[Cities_Archive]
GROUP BY [CityName]
ORDER BY [CityName] ASC
    OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

9.
/* 

    Write a query for the Sales.OrderLines table that returns:
    - unique stock items and their descriptions
    - ordered by stock item ID in ascending order
    - skip the first 29 rows then return only the next 50 rows


    | StockItemID | Description |
    -----------------------------

*/

SELECT DISTINCT [StockItemID], [Description]
FROM Sales.OrderLines
ORDER BY [StockItemID] ASC
    OFFSET 29 ROWS FETCH NEXT 50 ROWS ONLY;