/*
Feladat #2:
Használd a WideWorldImporters példa adatbázist!

Írj egy lekérdezést ami visszaadja csak azokat az ügyfeleket akiknek ismert a CreditLimit értékük és adtak le rendelést 2014 elsõ napja és 2015 utolsó napja között, de nem adtak le semmilyen rendelést 2013-ban.

Figyelj arra, hogy az évszám keresési feltétel lehetõleg SARG-able legyen (potenciális indexhasználat)!

A lekérdezés rendezze sorba az eredményt CustomerName alapján csökkenõ sorrendben!

Az alábbi táblákat használd:

Sales.Customers
Sales.Orders
A lekérdezés az alábbi oszlopokkal térjen vissza:

[customer_name]: CustomerName oszlop a Sales.Customers táblából
[credit_limit]: CreditLimit oszlop a Sales.Customers táblából
[account_opened_status]: AccountOpenedDate oszlop alapján a Sales.Customers táblából:
Ahol az AccountOpenedDate 2015.01.01 elõtti, ott az AccountOpenedDate helyett írja ki, hogy 'Before 2015'
*/

USE [WideWorldImporters];
GO

SELECT
    MAX([WideWorldImporters].[Sales].[Customers].[CustomerName])                            AS [customer_name],
    MAX([WideWorldImporters].[Sales].[Customers].[CreditLimit])                             AS [credit_limit],
    IIF(
        MAX([WideWorldImporters].[Sales].[Customers].[AccountOpenedDate]) < '20150101',
        'Before 2015',
        MAX([WideWorldImporters].[Sales].[Customers].[AccountOpenedDate])
    )                                                                                       AS [account_opened_status]
FROM [WideWorldImporters].[Sales].[Customers]

INNER JOIN [WideWorldImporters].[Sales].[Orders] AS a
    ON  a.[CustomerID]           = [WideWorldImporters].[Sales].[Customers].[CustomerID]
    AND a.[PickingCompletedWhen] BETWEEN '20140101' AND '20151231'

INNER JOIN [WideWorldImporters].[Sales].[Orders] AS b
   ON  b.[CustomerID]           = [WideWorldImporters].[Sales].[Customers].[CustomerID]
   AND b.[PickingCompletedWhen] NOT BETWEEN '20130101' AND '20131231'

WHERE [WideWorldImporters].[Sales].[Customers].[CreditLimit] IS NOT NULL
GROUP BY [WideWorldImporters].[Sales].[Customers].[CustomerID]