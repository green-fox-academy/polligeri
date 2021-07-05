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
--WITH TIES. The WITH TIES allows you to return 
--more rows with values that match the last row 
--in the limited result set. 
--Note that WITH TIES may cause more rows to be 
--returned than you specify in the expression. 
--For example, if you want to return the most expensive 
--products, you can use the TOP 1 .
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
SELECT TOP 10 CityID, [CityName], MAX([LatestRecordedPopulation]) AS [population] 
FROM [Application].[Cities_Archive]
GROUP BY CityID, [CityName]
ORDER BY [population] DESC;

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
SELECT CityID, [CityName], MAX([LatestRecordedPopulation]) AS [population] 
FROM [Application].[Cities_Archive]
GROUP BY CityID, [CityName]
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

10.
/* 
    
    Write queries with a WHERE clause with different predicates/expressions 
    to query data from the Application.Countries table. 
    
    Try the operators in the operator precedence list 
    and combine them with AND / OR.
    
    Test how the operator precedence works.


    | CountryID | CountryName |
    ---------------------------

*/

SELECT [Continent]
FROM [Application].[Countries_Archive]
WHERE [Continent] LIKE '%rop%'

SELECT [Continent]
FROM [Application].[Countries_Archive]
WHERE [Continent] = 'Asia'

SELECT CountryID, CountryName FROM Application.Countries
WHERE CountryID BETWEEN 1 AND 20


11.

/* 

    City populations in the Application.Cities table are sometimes UNKNOWN.
    
    Write a query that returns the city names where the populations are known.
    Write a query that returns the city names where the populations are UNKNOWN.
    Alias the LatestRecordedPopulation column as [population].

    | CityName | population |
    -------------------------

    Which operators do you need to use?

*/

SELECT [CityID], LatestRecordedPopulation as [population]
FROM Application.Cities
WHERE LatestRecordedPopulation IS NOT NULL

SELECT [CityID], LatestRecordedPopulation as [population]
FROM Application.Cities
WHERE LatestRecordedPopulation IS NULL


12.

/* 

    Write a query that returns the first 100 order ids with comments 
    from the Sales.Orders table.
    
    If a comment is UNKNOWN, display the string 'not available' instead.

    Try different methods to solve this problem.

    | OrderID | Comments |
    ----------------------

*/

SELECT TOP 100 [OrderID], [Comments], ISNULL([Comments], 'NOT AVAIBLE')
FROM Sales.Orders;

SELECT TOP 100 [OrderID], [Comments], COALESCE([Comments], 'NOT AVAIBLE')
FROM Sales.Orders;

13.

/* 

    Write queries for the Sales.Orders table that return orders that were placed
     - on a specific date
     - after a specific date
     - before a specific date
     - between specific dates
     - in one specific year
     - in multiple specific years
     - in a specific year and month
     - on the last day of a specific month
     - in different time intervals combined with AND/OR

    Watch out for the WHERE clause, try to avoid using functions 
    on the left hand side of your logical expressions!

    | OrderID | OrderDate |
    -----------------------

*/

SELECT [OrderDate]
FROM Sales.Orders
WHERE [OrderDate] = '20130101';

SELECT [OrderDate]
FROM Sales.Orders
WHERE [OrderDate] > '20130101';

SELECT [OrderDate]
FROM Sales.Orders
WHERE [OrderDate] < '2013-01-05';

SELECT [OrderDate]
FROM Sales.Orders
WHERE [OrderDate] BETWEEN '20130102' AND '2013-01-05';

SELECT [OrderDate]
FROM Sales.Orders
WHERE [OrderDate] = '2015';

SELECT [OrderDate]
FROM Sales.Orders
WHERE [OrderDate] = '2015' OR [OrderDate] = '2016';


SELECT [OrderDate]
FROM Sales.Orders
WHERE [OrderDate] LIKE '2015-01%';

SELECT MAX([OrderDate])
FROM Sales.Orders
WHERE [OrderDate] LIKE '2015-01%';

SELECT [OrderDate]
FROM Sales.Orders
WHERE [OrderDate] BETWEEN '2015' AND '2017';
/*
    Look up T-SQL functions that handle dates like the OrderDate column 
    in Sales.Orders:
     - YEAR
     - MONTH
     - EOMONTH
     - DATENAME
     - DATEPART
     - DATEADD
     - DATEDIFF

    Write queries that return new values based on the OrderDate column values 
    by using these functions in the SELECT list. 
    You can alias the new column(s) as you like (eg: [mydate])

    You can also apply different row filters to your query.

    | OrderID | OrderDate | mydate
    ------------------------------

*/
SELECT [OrderDate], 
YEAR([OrderDate]) AS [YEAR], 
MONTH([OrderDate]) AS [MONTH],
DAY([OrderDate]) AS [DAY]
FROM Sales.Orders;

SELECT [OrderDate], 
DATEDIFF(DAY, '20130101', '20150101') AS DIFF
FROM Sales.Orders;

14.

/*

    Use the Warehouse.StockItems table.

    Write queries that return stockitems with the following characteristics:
    - name starts with 'DBA'
    - name ends with 't'
    - name does not end with 'k'
    - name contains the word 'joke'
    - name starts with the letters 'a' or 'b' or 'c' or 'f'
    - name that does not contain the words 'flash drive'
    - name that contains the word 'ham' and the following character is not 'm'
    - name starts with 'a', next character can be anything between 'l' and 't' 
      and ends with any character between 'l' and 'p'
    - name is exactly 'DBA joke mug - it depends (Black)'

    | StockItemID | StockItemName |
    -------------------------------

*/

SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] LIKE 'DBA%';

SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] LIKE '%T';

SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] NOT LIKE '%K';

SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] LIKE '%JOKE%';

SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] LIKE 'A%' 
OR [StockItemName] LIKE 'B%' 
OR [StockItemName] LIKE 'C%' 
OR [StockItemName] LIKE'F%';
/*
SELECT StockItemID,StockItemName FROM Warehouse.StockItems
WHERE StockItemName LIKE '[a-c]%' OR StockItemName LIKE 'f%';
*/
SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] NOT LIKE '%FLASH DRIVE%';

SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] LIKE '%HAM%'
AND [StockItemName] NOT LIKE '%HAMM%';

SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] LIKE 'A%' 
AND SUBSTRING([StockItemName],2,1) BETWEEN 'L' AND 'T'
AND RIGHT([StockItemName], 1) BETWEEN 'L' AND 'P';

SELECT [StockItemName]
FROM Warehouse.StockItems
WHERE [StockItemName] = 'DBA joke mug - it depends (Black)';

15.
/* 
    
    Write a CASE expression query for the Sales.Orders table that return 
    order dates for the year 2013, but display a verbose quarter description too
     - if the order date is in the first quarter of 2013 
       write 'First quarter of 2013'
     - if the order date is in the second quarter of 2013 
       write 'Second quarter of 2013'
     - if the order date is in the third quarter of 2013 
       write 'Third quarter of 2013'
     - if the order date is in the fourth quarter of 2013 
       write 'Fourth quarter of 2013'

    | OrderID | OrderDate | quarter |
    ---------------------------------

*/
SELECT [OrderDate],
  CASE
    WHEN [OrderDate] BETWEEN '2013-01-01' AND '2013-03-31' THEN 'First quarter of 2013'
    WHEN [OrderDate] BETWEEN '2013-04-01' AND '2013-06-30' THEN 'Second quarter of 2013'
    WHEN [OrderDate] BETWEEN '2013-07-01' AND '2013-09-30' THEN 'Third quarter of 2013'
	WHEN [OrderDate] BETWEEN '2013-10-01' AND '2013-12-31' THEN 'Fourth quarter of 2013'
  END AS QUARTERS
FROM Sales.Orders;


16.

/* 
    
    CASE expressions can be used in other clauses too, other than SELECT.

    Write a query that uses conditional ordering.
    Order the people by their full name in the Application.People table
     - in ascending order if they are an employee
     - in descending order if they are a vendor (not an employee)

    | FullName | IsEmployee |
    -------------------------

*/
SELECT FullName, IsEmployee 
FROM Application.People
ORDER BY
CASE IsEmployee WHEN 1 THEN FullName END ASC,
CASE IsEmployee WHEN 0 THEN FullName END DESC;

17.
/* 

    Modify the below query:
     - to return only the last day orders in general from the Sales.Orders table

    | CustomerID | OrderID | OrderDate |
    ------------------------------------
SELECT CustomerID, OrderID, OrderDate 
FROM Sales.Orders
*/

SELECT CustomerID, OrderID, OrderDate 
FROM Sales.Orders
WHERE OrderDate = (SELECT MAX(OrderDate) 
FROM Sales.Orders);

18.

/* 

    Modify the below query:
     - to return the orders that each customer placed on their last order day 
       from the Sales.Orders table

    | CustomerID | OrderID | OrderDate |
    ------------------------------------

SELECT CustomerID, OrderID, OrderDate 
FROM Sales.Orders;
*/

SELECT DISTINCT CustomerID, OrderID, OrderDate 
FROM Sales.Orders
WHERE OrderDate = (SELECT MAX(OrderDate) 
FROM Sales.Orders);

19.
/* 

    Modify the below query per the following:
     - add a new column that shows the maximum quantity for the StockItemID
     - add yet another column that shows the difference between the maximum 
       quantity for the StockItemID and each order quantity

    | OrderID | StockItemID | Quantity | Max_StockItem_Qty | Max_Diff_Qty |


SELECT OrderID, StockItemID, Quantity
FROM Sales.OrderLines
WHERE StockItemID = 180;
*/
SELECT OrderID, StockItemID, Quantity, 
(SELECT MAX(DISTINCT Quantity) FROM Sales.OrderLines) AS MAXQ
FROM Sales.OrderLines
WHERE StockItemID = 180;

SELECT MAX(Quantity)-SUM(Quantity) FROM Sales.OrderLines
GROUP BY Quantity;

20.
/* 

    Modify the below query:
     - to return only those customers whose name starts with 'Anna'
     - AND did not place any orders in January 2014

    | CustomerID | CustomerName |
    -----------------------------


SELECT CustomerID, CustomerName
FROM Sales.Customers;
*/
SELECT CustomerID, CustomerName
FROM Sales.Customers
WHERE CustomerName LIKE ('Anna%')
AND NOT EXISTS (SELECT [OrderDate] FROM [Sales].[Orders]
WHERE [OrderDate] > '2014-01-01' AND [OrderDate] < '2014-01-31');


21.
/* 

    Work with the following queries

*/
/* 

    Query1 - returns persons who are referenced in Sales.Orders 
             as PickedByPersonID 
    It returns 19 persons (rows).

*/
SELECT PersonID, FullName
FROM Application.People
WHERE PersonID IN (SELECT o.PickedByPersonID
                   FROM Sales.Orders o);

/* 

    Query2 - should return persons who are NOT referenced in Sales.Orders 
             as PickedByPersonID 
    It returns UNKNOWN. (no results)

    Why is that?

*/
SELECT PersonID, FullName
FROM Application.People
WHERE PersonID NOT IN (SELECT o.PickedByPersonID
                       FROM Sales.Orders o);
					   NULLS


/* 

    Query3 - Resolve the problem so that the NOT IN query does return rows.

*/
SELECT PersonID, FullName
FROM Application.People a
WHERE PersonID IN (SELECT o.PickedByPersonID
                       FROM Sales.Orders o WHERE a.PersonID = o.PickedByPersonID);


/* 

    Query4 - How would you rewrite the NOT IN query with EXISTS?

*/
SELECT PersonID, FullName
FROM Application.People a
WHERE EXISTS (SELECT o.PickedByPersonID
                       FROM Sales.Orders o WHERE a.PersonID = o.PickedByPersonID);

22.
/*

    Modify the below query to return these columns 
    from the Application.Cities table:
     - cnt_all: count of all rows
     - cnt_pop: count of the LatestRecordedPopulation column values
     - max_pop: maximum value of LatestRecordedPopulation
     - min_pop: minimum value of LatestRecordedPopulation
     - sum_pop: sum aggregate of LatestRecordedPopulation
     - avg_pop: avg of LatestRecordedPopulation

   
    What does each column value show?

    | cnt_all | cnt_pop | max_pop | min_pop | sum_pop | avg_pop |
    -------------------------------------------------------------

*/
SELECT COUNT(*) AS cnt_all, COUNT(DISTINCT LatestRecordedPopulation) AS cnt_pop, MAX(LatestRecordedPopulation)AS max_pop,
MIN(LatestRecordedPopulation) AS min_pop, SUM(LatestRecordedPopulation) AS sum_pop,
AVG(LatestRecordedPopulation) AS avg_pop
FROM Application.Cities;


/*

    Apply a WHERE filter to either:
     - calculate with only known LatestRecordedPopulation values
     - OR calculate with only unknown LatestRecordedPopulation values

    How does the result change?

    | cnt_all | cnt_pop | max_pop | min_pop | sum_pop | avg_pop |
    -------------------------------------------------------------
*/
SELECT COUNT(*) AS cnt_all, COUNT(DISTINCT LatestRecordedPopulation) AS cnt_pop, MAX(LatestRecordedPopulation)AS max_pop,
MIN(LatestRecordedPopulation) AS min_pop, SUM(LatestRecordedPopulation) AS sum_pop,
AVG(LatestRecordedPopulation) AS avg_pop
FROM Application.Cities
WHERE LatestRecordedPopulation IS NOT NULL;

SELECT COUNT(*) AS cnt_all, COUNT(DISTINCT LatestRecordedPopulation) AS cnt_pop, MAX(LatestRecordedPopulation)AS max_pop,
MIN(LatestRecordedPopulation) AS min_pop, SUM(LatestRecordedPopulation) AS sum_pop,
AVG(LatestRecordedPopulation) AS avg_pop
FROM Application.Cities
WHERE LatestRecordedPopulation IS NULL;
/*
  
    Modify this new WHERE filter query and make sure that:
     - the cnt_pop column always show the very same value as cnt_all 
       no matter what the filter is

    | cnt_all | cnt_pop | max_pop | min_pop | sum_pop | avg_pop |
    -------------------------------------------------------------

*/
SELECT COUNT(*) AS cnt_all, COUNT(LatestRecordedPopulation) AS cnt_pop, MAX(LatestRecordedPopulation)AS max_pop,
MIN(LatestRecordedPopulation) AS min_pop, SUM(LatestRecordedPopulation) AS sum_pop,
AVG(LatestRecordedPopulation) AS avg_pop
FROM Application.Cities
WHERE LatestRecordedPopulation IS NOT NULL;


/*

    Modify the original (not filtered) query by adding a new column:
     - cnt_unknown_pop: count of only the unknown LatestRecordedPopulation 
       values

 | cnt_all | cnt_pop | cnt_unknown_pop | max_pop | min_pop | sum_pop | avg_pop |
 -------------------------------------------------------------------------------

*/
SELECT 
COUNT(*) AS cnt_all, 
COUNT(LatestRecordedPopulation) AS cnt_pop, 
COUNT(COALESCE(LatestRecordedPopulation,0)) AS cnt_unknown_pop,
MAX(LatestRecordedPopulation)AS max_pop,
MIN(LatestRecordedPopulation) AS min_pop, 
SUM(LatestRecordedPopulation) AS sum_pop,
AVG(LatestRecordedPopulation) AS avg_pop
FROM Application.Cities;

23.
/* 

    Write a query for the Sales.Orders table that:
     - returns OrderDate year groups
     - calculate the number of OrderIDs for each group
     - order the results by OrderDate year in descending order
  
    | orderyear | cnt_order |
    -------------------------
*/
SELECT YEAR(OrderDate) AS orderyear, COUNT(OrderID) AS cnt_order
FROM Sales.Orders
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) DESC;

/* 

    Modify the query:
     - group on OrderDate year AND OrderDate month
     - calculate the number of OrderIDs for each group
     - order the results by OrderDate year in descending order
       and Orderdate month in ascending order

    | orderyear | ordermonth | cnt_order |
    --------------------------------------
*/
SELECT YEAR(OrderDate) AS orderyear, MONTH(OrderDate) as ordermonth, COUNT(OrderID) as cnt_order
FROM Sales.Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate) DESC, MONTH(OrderDate) ASC;


/* 

    Modify the query:
     - to return only those groups that have more than 2000 OrderIDs

    | orderyear | ordermonth | cnt_order |
    --------------------------------------

*/
SELECT YEAR(OrderDate) AS orderyear, MONTH(OrderDate) as ordermonth, COUNT(OrderID) as cnt_order
FROM Sales.Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING SUM(YEAR(OrderDate)) > 2000 AND SUM(MONTH(OrderDate)) > 2000
ORDER BY YEAR(OrderDate) DESC, MONTH(OrderDate) ASC;


24.
/* 

    Write a query for the Sales.OrderLines table that:
     - returns StockItemID groups
     - calculate the sum aggregate of quantities for each group
     - order the results by StockItemID in ascending order
  
    | StockItemID | sum_qty |
    -------------------------

*/
SELECT StockItemID, SUM([Quantity]) AS sum_qty
FROM Sales.OrderLines
GROUP BY StockItemID
ORDER BY StockItemID ASC;


/* 

    Modify the query:
     - group only those order lines where the quantity >= 10
     - count only those order lines where the quantity >= 10

    | StockItemID | sum_qty | cnt_qty |
    -----------------------------------
*/

SELECT StockItemID,SUM(Quantity) as sum_qty, COUNT(Quantity) as cnt_qty FROM Sales.OrderLines
WHERE Quantity >=10
GROUP BY StockItemID
ORDER BY StockItemID ASC

/* 

    Modify the latest query:
     - to return only those groups where the sum_qty aggregate > 10000

    | StockItemID | sum_qty | cnt_qty |
    -----------------------------------


*/

SELECT StockItemID,SUM(Quantity) as sum_qty, COUNT(Quantity) as cnt_qty FROM 
Sales.OrderLines
WHERE Quantity >=10
GROUP BY StockItemID
HAVING SUM(Quantity) > 10000
ORDER BY StockItemID ASC

25.
/* 

    Write a query on the Sales.OrderLines table that:
     - create groups of stock item IDs and their sum aggregate quantities
     - return only those groups that contain more than 1100 rows

    | StockItemID | sum_qty |
    -------------------------
*/

SELECT StockItemID, SUM(Quantity) AS sum_qty FROM Sales.OrderLines 
CROSS APPLY (SELECT COUNT(Quantity) AS cq FROM Sales.OrderLines) AS a
WHERE 1100 < cq
GROUP BY StockItemID;

26.
/* 

    Write a query for the Sales.Orders table that:
     - counts the order dates 
     - counts the unique order dates

    | cnt_orderdate | cnt_unique_orderdate |
    ----------------------------------------
*/
SELECT COUNT([OrderDate]) AS cnt_orderdate, COUNT(DISTINCT [OrderDate]) AS cnt_unique_orderdate
FROM Sales.Orders;

27.DerivedTableOrder
/*

    Modify the below query to return the results in order:
     - orderyear in ascending
     - ordermonth in descending

    Where do you have to add the ordering clause? Why?

    | orderyear | ordermonth | cnt_cust |
    -------------------------------------

*/

SELECT D.orderyear, D.ordermonth, COUNT(DISTINCT D.custID) AS cnt_cust
FROM (SELECT YEAR(OrderDate), MONTH(OrderDate), CustomerID
      FROM Sales.Orders) AS D(orderyear, ordermonth, custID)
GROUP BY D.orderyear, D.ordermonth
ORDER BY D.orderyear ASC, D.ordermonth DESC;

28.derived-table-or-subquery

/*

    Modify the below query to use a derived table


    | CustomerID | OrderID | OrderDate |
    ------------------------------------

    Hint: you may also need to use a JOIN operator


*/
/*
SELECT CustomerID, OrderID, OrderDate
FROM Sales.Orders o1
WHERE OrderID =
  (SELECT MAX(o2.OrderID)
   FROM Sales.Orders o2
   WHERE o2.CustomerID = o1.CustomerID);
  */

SELECT DISTINCT o1.CustomerID, o1.OrderID, o1.OrderDate
FROM (SELECT CustomerID, OrderID, OrderDate FROM Sales.Orders) o1
INNER JOIN (SELECT CustomerID, OrderID, OrderDate FROM Sales.Orders) o2
ON
o1.OrderID =
  (SELECT MAX(o2.OrderID)
   FROM Sales.Orders o2
   WHERE o2.CustomerID = o1.CustomerID);

!29.PivotReport

/*

    While pivoting is an advanced concept and we don't cover it
    still you can do this with the language elements learned so far.

    Write a query that creates a report that shows the sum aggregated order
    quantities for each CustomerID per each year, 2013, 2014, 2015 and 2016.

    The query should return in the following format:

    | CustomerID | 2013 | 2014 | 2015 | 2016 |
    ------------------------------------------
*/



30.
/*

    Use the Application.Countries table.

    Write a query that returns all the European countries, by using a CTE.

*/
WITH Countries_CTE ([CountryName])  
AS
(  
    SELECT [CountryName] 
    FROM Application.Countries  
    WHERE Continent = 'Europe'  
)
SELECT [CountryName] FROM Countries_CTE;

31.CteOrSubquery
USE WideWorldImporters;
/*

    Modify the below query to use a CTE


    | CustomerID | OrderID | OrderDate |
    ------------------------------------

    Hint: you may also need to use a JOIN operator


*/

WITH o2 (CustomerID,OrderID) AS (
    SELECT CustomerID,MAX(OrderID) AS OrderID FROM Sales.Orders
    GROUP BY CUstomerID
)
SELECT o1.CustomerID, o1.OrderID, o1.OrderDate
FROM Sales.Orders o1 INNER JOIN Sales.Orders o2 ON o1.CustomerID = o2.CustomerID
WHERE o1.OrderID=o2.OrderID



32.city-sets

/*
    Work with the Application.Cities table.

    1.         
        Write a query that counts the cities (all rows) 
        in the state of Colorado.
        This is the total number of cities you work with. 

        | cnt_city_colorado |
        ---------------------
		*/
		SELECT COUNT([CityID]) AS cnt_city_colorado
		FROM Application.Cities
		WHERE [StateProvinceID] = 6;

  /*  2.
        Write a query to return all cities from the state of Colorado 
        where the population is known.

        | CityID | CityName | population |
        ----------------------------------
*/
SELECT [CityID], CityName, [LatestRecordedPopulation] AS population
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] IS NOT NULL;


/*
        Write a query to return all cities from the state of Colorado 
        where the population is UNKNOWN.

        | CityID | CityName | population |
        ----------------------------------
*/
SELECT [CityID], CityName, [LatestRecordedPopulation] AS population
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] IS NULL;


/*
    3.
        Combine (unify) the known and unknown city query results with the 
        appropriate set operator.
        Which set operator should you use? UNION ALL
        In which query do you have to specify the column alias "population"? First

        How many rows did you get? 588
*/
 SELECT [CityID], CityName, [LatestRecordedPopulation] AS population
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] IS NOT NULL
		UNION ALL
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] IS NULL;


/* 4.
        Add ordering to the combined query by population in ascending order.

        Where do you have to add the ordering clause? Second query  

*/
 SELECT [CityID], CityName, [LatestRecordedPopulation] AS population
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] IS NOT NULL
		UNION ALL
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] IS NULL
		ORDER BY [LatestRecordedPopulation] ASC;


/*

    Remove the known and unknown filters from your queries.
    Leave the Colorado state filter in both queries.

	*/
	 SELECT [CityID], CityName, [LatestRecordedPopulation] AS population
		FROM Application.Cities
		WHERE [StateProvinceID] = 6
		UNION
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6
		ORDER BY [LatestRecordedPopulation] ASC;
	/*

    1. 
        Add a WHERE filter to the first query to return cities where the 
        population > 1000.
*/
SELECT [CityID], CityName, [LatestRecordedPopulation] AS population 
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 1000
		UNION
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6
		ORDER BY [LatestRecordedPopulation] ASC;
/*
    2.
        Add a WHERE filter to the second query to return cities where the 
        population < 5000.
		*/
		SELECT [CityID], CityName, [LatestRecordedPopulation] AS population 
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 1000
		UNION
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 5000
		ORDER BY [LatestRecordedPopulation] ASC;
		/*

    3.
        Use the UNION ALL operator to combine the queries.
*/
		SELECT [CityID], CityName, [LatestRecordedPopulation] AS population 
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 1000
		UNION ALL
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 5000
		ORDER BY [LatestRecordedPopulation] ASC;
/*
    4.
        Add ordering to the combined query by population in ascending order.

    Browse the results.
    What do you notice?No NULLS 246rows
*/
		SELECT [CityID], CityName, [LatestRecordedPopulation] AS population 
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 1000
		UNION ALL
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 5000
		ORDER BY [LatestRecordedPopulation] ASC;
/*
    5.
        Use the UNION operator instead and rerun the combined query.

    What changed and why? 164rows
*/
SELECT [CityID], CityName, [LatestRecordedPopulation] AS population 
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 1000
		UNION
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 5000
		ORDER BY [LatestRecordedPopulation] ASC;

		--UNION is distinct


/*

    Modify your combined query so that you only return the rows that appear 
    in BOTH query results.

    Which set operator should you use? INTERSECT

*/
SELECT [CityID], CityName, [LatestRecordedPopulation] AS population 
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 1000
		INTERSECT
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 5000
		ORDER BY [LatestRecordedPopulation] ASC;
/*
    Modify your combined query so that you only return the rows that appear 
    in the first query results and not in the second.

    Which set operator should you use? EXCEPT
*/
SELECT [CityID], CityName, [LatestRecordedPopulation] AS population 
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 1000
		EXCEPT
SELECT [CityID], CityName, [LatestRecordedPopulation]
		FROM Application.Cities
		WHERE [StateProvinceID] = 6 AND [LatestRecordedPopulation] > 5000
		ORDER BY [LatestRecordedPopulation] ASC;
33.order-sets

/*
    Return customers from the Sales.Orders table that have orders both 
    in May 2013 and June 2015.

    | CustomerID |
    --------------


*/

SELECT DISTINCT CustomerID FROM Sales.Orders
WHERE 2013 = YEAR(OrderDate) AND 5 = MONTH(OrderDate)
INTERSECT
SELECT DISTINCT CustomerID FROM Sales.Orders
WHERE 2015 = YEAR(OrderDate) AND 6 = MONTH(OrderDate);

/*
    Return customers from the Sales.Orders table that have orders 
    in September 2013 but not in October 2015.

    | CustomerID |
    --------------


*/


SELECT DISTINCT CustomerID FROM Sales.Orders
WHERE 2013 = YEAR(OrderDate) AND 9 = MONTH(OrderDate)
EXCEPT
SELECT DISTINCT CustomerID FROM Sales.Orders
WHERE 2015 = YEAR(OrderDate) AND 10 = MONTH(OrderDate)
ORDER BY CustomerID;


34.
/*

    Modify the below query to return cities from the states of Arizona, 
    Washington and Utah and also display the name of their states.

    Order the results by State Name in ascending order.

    | CityID | CityName | State Name |
    ----------------------------------
    Hint: the Application.Cities and the Application.StateProvinces tables 
          both have a StateProvinceID column that you should use.
SELECT
FROM Application.Cities 
      Application.StateProvinces
	  */

SELECT CityID, CityName, StateProvinceName AS 'State Name'
FROM Application.Cities ac
INNER JOIN Application.StateProvinces sp
ON ac.StateProvinceID = sp.StateProvinceID
WHERE StateProvinceName IN ('Arizona','Utah','Washington')
ORDER BY StateProvinceName ASC;

35.

/*

    Write a query that returns a report for specific Orders.

    Each order has detailed orderlines that show what items were ordered and 
    in which quantity.

    Use the Sales.Orders and Sales.OrderLines tables. Sales.OrderLines has an 
    OrderID column that you should use.
    Return only those orders that were placed between '2013-05-01' and 
    '2013-06-30' and belong to CustomerID = 50.
    Order the results by OrderDate in descending order.
    | OrderID | OrderLineID | CustomerID | OrderDate | StockItemID |
    | Description | Quantity |
    ----------------------------------------------------------------
*/
SELECT o.OrderID, OrderLineID, CustomerID, OrderDate, StockItemID, Description, Quantity
FROM Sales.Orders o
INNER JOIN Sales.OrderLines ol
ON o.OrderID = ol.OrderID
WHERE OrderDate > '2013-05-01' AND OrderDate < '2013-06-30' AND CustomerID = 50
ORDER BY OrderDate DESC;

36.
/*

    Write a query that returns a report for specific Orders.

    Each order has detailed orderlines that show what items were ordered and 
    in which quantity.
    Use the Sales.Orders and Sales.OrderLines tables. Sales.OrderLines has 
    an OrderID column that you should use.
    Return the 5 highest aggregated order quantity for those orders 
    that were placed between '2013-09-01' and '2013-12-31' and 
    belong to CustomerID = 100.
    | OrderID | sum_qty |
    ---------------------
*/
SELECT TOP 5 o.OrderID, SUM(Quantity) AS sum_qty
FROM Sales.Orders o
INNER JOIN Sales.OrderLines ol
ON o.OrderID = ol.OrderID
WHERE OrderDate > '2013-09-01' AND OrderDate < '2013-12-31' AND CustomerID = 100
GROUP BY o.OrderID
ORDER BY SUM(Quantity) DESC;

37.
/*

    Write a query that returns a report for specific Customers.
    Each order has detailed orderlines that show what items were ordered and 
    in which quantity.
    This time you'll need to work with more than two tables!
    This is called a multi-join query.
    Use the Sales.Customers, Sales.Orders and Sales.OrderLines tables. 
    Sales.OrderLines has an OrderID column that you should use.
    Sales.Orders has a CustomerID column that you should use.
    Return those 5 customers who ordered the most quantities in 2015.
   | CustomerID | CustomerName | sum_qty |
    ---------------------------------------
*/
SELECT TOP 5 c.CustomerID, CustomerName, SUM(Quantity) AS sum_qty
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
INNER JOIN Sales.OrderLines ol
ON o.OrderID = ol.OrderID
WHERE OrderDate LIKE '2015%'
GROUP BY c.CustomerID, CustomerName
ORDER BY CustomerName DESC;


38.TopCities
/*

    Write a query that returns a report for specific Cities.

    Each order has detailed orderlines that show what items were ordered and
    in which quantity.

    This time you'll need to work with more than two tables!
    This is called a multi-join query.

    Return those 5 cities where customers ordered the most aggregated quantities
    on the last days of any month in 2016.
    If the aggregated quantity is:
     - greater than 800 display 'Exceptional'
     - between 700 and 800 display 'Good'
     - below 700 display 'Average'
    Alias the sales classification as [sales].


    | CityName | sum_qty | sales |
    ------------------------------
*/

SELECT TOP 5 CityName, SUM(Quantity) AS sum_qty, 
CASE 
    WHEN 800 < SUM(Quantity) THEN 'Exceptional'
    WHEN SUM(Quantity) BETWEEN 700 AND 800 THEN 'Good'
    ELSE 'Average'
END AS sales 
FROM Sales.OrderLines ol 
INNER JOIN Sales.Orders o
ON ol.OrderID = o.OrderID 
AND 2016 = YEAR(OrderDate) AND OrderDate = EOMONTH(OrderDate) 
INNER JOIN Sales.Customers c ON
c.CustomerID = o.CustomerID 
INNER JOIN Application.Cities ac ON
ac.CityID = c.DeliveryCityID
GROUP BY CityName
ORDER BY SUM(Quantity) DESC;

39.OrdersPickedBy
/*

    Write a query that returns all the orders and match them with persons 
    who picked up the order.

    Return only those orders that were placed in March 2014.

    | OrderID | FullName |
    ----------------------

    What do you see in the resultset?
	--ANSWER: THERE are many NULL values.
    How do you display only those rows that don't match?
	SELECT OrderID,Fullname FROM Sales.Orders LEFT JOIN Application.People ON 
Sales.Orders.PickedByPersonID=Application.People.PersonID 
WHERE 2014=YEAR(OrderDate) AND 3=MONTH(OrderDate) AND FullName is NULL
    How can you make the original query look like an INNER JOIN with a 
    WHERE predicate?
	SELECT OrderID,Fullname FROM Sales.Orders LEFT JOIN Application.People ON 
Sales.Orders.PickedByPersonID=Application.People.PersonID 
WHERE 2014=YEAR(OrderDate) AND 3=MONTH(OrderDate) AND FullName is not NULL
*/
SELECT OrderID, Fullname 
FROM Sales.Orders so 
LEFT JOIN [Application].[People] ap 
ON so.PickedByPersonID = ap.PersonID 
WHERE 2014 = YEAR(OrderDate) AND 3 = MONTH(OrderDate);
/*

    Apply a filter in your original query that filters for full names that 
    start with 'Hudson'.

    What do you notice?

*/
SELECT OrderID, Fullname 
FROM Sales.Orders so 
LEFT JOIN [Application].[People] ap 
ON so.PickedByPersonID = ap.PersonID 
WHERE 2014 = YEAR(OrderDate) AND 3 = MONTH(OrderDate) AND Fullname LIKE 'Hudson%';

40.CountOrdersPickedBy
/*

    Write a query that returns all the customer IDs from orders and match the 
    orders with persons who picked up the order.

    Return only those orders that were placed in March 2014.
    Make customer groups and count how many persons there are in each group.

    | CustomerID | cnt_persons |
    ----------------------------

    Watch out for using the COUNT function!
    How should you use the COUNT function? Why?

*/

SELECT CustomerID, COUNT(DISTINCT PickedByPersonID) AS cnt_persons 
FROM Sales.Orders
WHERE 2014 = YEAR(OrderDate) AND 3 = MONTH(OrderDate)
GROUP BY CustomerID;
--Specifies that COUNT returns the number of unique nonnull values.
41.cross-join-countries
/*

    Modify the below query to do a CROSS JOIN.

    Moreover, this is a special type of join too, a self-join.
    The query joins the Application.Countries table to itself.


    | left_id | left_name | right_id | right_name |
    -----------------------------------------------

    How many rows do you get? Why? 36100,  190 * 190 = 36100, Descartes:)

*/
SELECT a.CountryID left_id, a.CountryName left_name, 
       ac.CountryID right_id, ac.CountryName right_name
FROM Application.Countries a 
CROSS JOIN Application.Countries ac;
	 


!42.number-generator
/*

    You haven't learned about creating tables yet, so you'll work with 'virtual'
    tables.
    This is a special use case of VALUES which you'll also use when inserting 
    data into tables.

    There are two sets: 
     - m with a column named mynumber, and with column values from 0 to 9
     - n with a column named mynumber, and with column values from 0 to 9
    These act as two tables that you can join and select from.

    Modify the below query so that you get m * n unique numbers (10 * 10 = 100),
    ordered from 1 to 100.

*/


 43.subqueries-or-joins
/*

    Rewrite the following subqueries as join queries.

*/

SELECT OrderID, OrderDate
FROM Sales.Orders
WHERE CustomerID IN
  (SELECT CustomerID
   FROM Sales.Customers
   WHERE PostalCityID = 33832);

SELECT o.OrderID, o.OrderDate
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON c.CustomerID = o.CustomerID
WHERE PostalCityID = 33832;

SELECT CustomerID, CustomerName
FROM Sales.Customers c
WHERE CustomerName LIKE 'Anna%'
    AND EXISTS (SELECT * FROM Sales.Orders o
                WHERE c.CustomerID = o.CustomerID
                AND o.OrderDate >= '20140101' AND o.OrderDate < '20140201');

SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Sales.Customers c
INNER JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE CustomerName LIKE 'Anna%' AND o.OrderDate >= '20140101' AND o.OrderDate < '20140201';


SELECT CustomerID, CustomerName
FROM Sales.Customers c
WHERE CustomerName LIKE 'Anna%'
    AND NOT EXISTS (SELECT * FROM Sales.Orders o
                    WHERE c.CustomerID = o.CustomerID
                    AND o.OrderDate >= '20140101' AND o.OrderDate < '20140201');

SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE CustomerName LIKE 'Anna%' AND NOT EXISTS (SELECT * FROM Sales.Orders o
                    WHERE c.CustomerID = o.CustomerID
                    AND o.OrderDate >= '20140101' AND o.OrderDate < '20140201');
