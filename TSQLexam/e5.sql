/*
Exercise #5:
Create a scalar user-defined function with schemabinding 
in the Sales schema named LatestCustomerOrderDate.
Return the latest (most recent) OrderDate when the customer placed an order. 
The CustomerID is passed as a parameter.
The function should return with a Date type value (OrderDate).
Use the following tables:
•	Sales.Orders
The function should accept one parameter:
•	@customerid int
Showcase how you use the scalar user-defined function in a query!

*/

DROP FUNCTION IF EXISTS Sales.LatestCustomerOrderDate;
GO
CREATE FUNCTION Sales.LatestCustomerOrderDate (@customerid int) RETURNS DATE
WITH SCHEMABINDING
AS
RETURN 
(
    SELECT
       TOP 1 OrderDate
    FROM Sales.Orders
    WHERE CustomerID = @customerid
    ORDER BY OrderDate DESC
);

SELECT * FROM Sales.LatestCustomerOrderDate(3);
