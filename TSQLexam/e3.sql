/*
Exercise #3
Create a report of States and the number of Cities that are in each State.
Return only those States that have more than 500 cities.
Order the report by the Number of Cities in descending order.
Use the following tables:
•	Application.StateProvinces
•	Application.Cities
The report should display the following columns:
•	[State]: StateProvinceName from the Application.StateProvinces table
•	[Number of Cities] : the number of cities in each State

*/

SELECT StateProvinceName AS [State], COUNT([CityID]) AS [Number of Cities]
FROM Application.StateProvinces S
INNER JOIN Application.Cities C
ON S.[StateProvinceID] = C.[StateProvinceID] 
GROUP BY StateProvinceName
HAVING COUNT([CityID]) > 500
ORDER BY [Number of Cities] DESC;