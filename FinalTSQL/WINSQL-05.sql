/*
Feladat #5:
Futtasd le a következõ szkriptet:
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
Készíts egy tárolt eljárást az Exam sémába InsertLogDate néven.

A tárolt eljárás egy új rekordot ad az Exam.LogAudit táblához.

A tárolt eljárásnak a rekord létrehozásához szükséges paramétert kell fogadnia:

@logdate date
Ha a rekord beillesztése sikeres volt, akkor az eljárás adja vissza a frissen beillesztett adat LogAuditId-ját.

Hibáknál használj hibakezelést, ami visszaadja a hiba számát és üzenetét:

print: 'Insert of log audit failed!'
print: 'Error number: ' és az error száma
print: 'Error message: ' és az error üzenete
térjen vissza -1 értékkel
Mutass egy példát az eljárás használatára!

A tárolt eljárást úgy írd meg, hogy a futás után ne jelenjen meg az "n rows affected" üzenet a Messages fülön!
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