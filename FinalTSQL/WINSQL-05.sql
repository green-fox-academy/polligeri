/*
Feladat #5:
Futtasd le a k�vetkez� szkriptet:
*/

USE ExamDB;
GO
DROP TABLE IF EXISTS Exam.LogAudit;
GO
DROP SCHEMA IF EXISTS Exam;
GO
CREATE SCHEMA Exam;
GO
CREATE TABLE Exam.LogAudit
(
    LogAuditId int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    LogDate date NOT NULL
);

/*
K�sz�ts egy t�rolt elj�r�st az Exam s�m�ba InsertLogDate n�ven.

A t�rolt elj�r�s egy �j rekordot ad az Exam.LogAudit t�bl�hoz.

A t�rolt elj�r�snak a rekord l�trehoz�s�hoz sz�ks�ges param�tert kell fogadnia:

@logdate date
Ha a rekord beilleszt�se sikeres volt, akkor az elj�r�s adja vissza a frissen beillesztett adat LogAuditId-j�t.

Hib�kn�l haszn�lj hibakezel�st, ami visszaadja a hiba sz�m�t �s �zenet�t:

print: 'Insert of log audit failed!'
print: 'Error number: ' �s az error sz�ma
print: 'Error message: ' �s az error �zenete
t�rjen vissza -1 �rt�kkel
Mutass egy p�ld�t az elj�r�s haszn�lat�ra!

A t�rolt elj�r�st �gy �rd meg, hogy a fut�s ut�n ne jelenjen meg az "n rows affected" �zenet a Messages f�l�n!
*/

DROP PROCEDURE IF EXISTS [Exam].[InsertLogAudit];
GO
CREATE PROCEDURE [Exam].[InsertLogAudit]
    @logdate DATE
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON
        INSERT INTO [Exam].[LogAudit] ([LogDate]) VALUES (@logdate)
        SET NOCOUNT ON
        SELECT SCOPE_IDENTITY() AS LogAuditId
    END TRY
    BEGIN CATCH
        PRINT 'Insert of log audit failed!'
        PRINT CONCAT('Error number: ', ERROR_NUMBER())
        PRINT CONCAT('Error message: ', ERROR_MESSAGE())
        SET NOCOUNT ON
        SELECT -1
    END CATCH
END
GO

EXEC [Exam].[InsertLogAudit] '2021-09-06'
GO