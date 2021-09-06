/*
Feladat #2:
Haszn�ld a WideWorldImporters p�lda adatb�zist!

�rj egy lek�rdez�st ami visszaadja csak azokat az �gyfeleket akiknek ismert a CreditLimit �rt�k�k �s adtak le rendel�st 2014 els� napja �s 2015 utols� napja k�z�tt, de nem adtak le semmilyen rendel�st 2013-ban.

Figyelj arra, hogy az �vsz�m keres�si felt�tel lehet�leg SARG-able legyen (potenci�lis indexhaszn�lat)!

A lek�rdez�s rendezze sorba az eredm�nyt CustomerName alapj�n cs�kken� sorrendben!

Az al�bbi t�bl�kat haszn�ld:

Sales.Customers
Sales.Orders
A lek�rdez�s az al�bbi oszlopokkal t�rjen vissza:

[customer_name]: CustomerName oszlop a Sales.Customers t�bl�b�l
[credit_limit]: CreditLimit oszlop a Sales.Customers t�bl�b�l
[account_opened_status]: AccountOpenedDate oszlop alapj�n a Sales.Customers t�bl�b�l:
Ahol az AccountOpenedDate 2015.01.01 el�tti, ott az AccountOpenedDate helyett �rja ki, hogy 'Before 2015'
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