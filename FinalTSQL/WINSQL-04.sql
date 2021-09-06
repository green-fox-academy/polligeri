/*
Feladat #4:
Használd az ExamDB példa adatbázist!

Elõzetesen futtasd le az alábbi script-et:
*/
USE ExamDB;
GO
DROP PROCEDURE IF EXISTS State.Proc1
GO
DROP SCHEMA IF EXISTS State;
GO
CREATE SCHEMA State;
GO
CREATE PROCEDURE State.Proc1
AS
SELECT 1;

/*
Írj egy T-SQL script-et ami az alábbiakat tartalmazza:

Létrehoz egy "StateAdminLogin" nevû SQL login-t egy jelszóval és a ExamDB adatbázist jelöli meg mint alapértelmezett adatbázis.
*/
USE [master]
GO
CREATE LOGIN [StateAdminLogin] WITH PASSWORD=N'qweASD123' MUST_CHANGE, DEFAULT_DATABASE=[ExamDB], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

/*
Létrehoz egy "StateStudentLogin" nevû SQL login-t egy jelszóval és a ExamDB adatbázist jelöli meg mint alapértelmezett adatbázis.
*/
USE [master]
GO
CREATE LOGIN [StateStudentLogin] WITH PASSWORD=N'asdQWE123' MUST_CHANGE, DEFAULT_DATABASE=[ExamDB], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

/*
Az ExamDB adatbázisban létrehoz egy "StateAdminUser" felhasználót az elõbbi, "StateAdminLogin" login-hoz.
*/
USE [ExamDB]
GO
CREATE USER [StateAdminUser] FOR LOGIN [StateAdminLogin]
GO

/*
Az ExamDB adatbázisban létrehoz egy "StateStudentUser" felhasználót az elõbbi, "StateStudentLogin" login-hoz.
*/
USE [ExamDB]
GO
CREATE USER [StateStudentUser] FOR LOGIN [StateStudentLogin]
GO

/*
Létrehoz egy új adatbázis szerepet (role) az ExamDB adatbázisban, "state_admin" néven.
*/
USE [ExamDB]
GO
CREATE ROLE [state_admin]
GO

/*
A "StateAdminUser" felhasználót hozzáadja az "state_admin" adatbázis szerephez.
*/
USE [ExamDB]
GO
ALTER ROLE [state_admin] ADD MEMBER [StateAdminUser]
GO

/*
A "StateStudentUser" felhasználót hozzáadja egy olyan fix adatbázis szerephez, ami megtagadja a hozzáférést az adatok módosítására (INSERT, UPDATE, DELETE) az ExamDB adatbázisban.
*/
USE [ExamDB]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [StateStudentUser]
GO

/*
Az State sémára EXECUTE jogot ad az "state_admin" adatbázis szerepnek.
*/
USE [ExamDB]
GO
GRANT EXECUTE ON SCHEMA::[State] TO [state_admin]
GO

/*
Teszteli az State.Proc1 tárolt eljárás futtatását a "StateAdminUser" felhasználó megszemélyesítésével.
Visszaállítja a végrehajtás kontextusát az elõzõ felhasználóra.
Lekérdezi a jelenlegi felhasználó nevét és a login nevét.
*/
USE [ExamDB]
GO
EXECUTE AS USER = 'StateAdminUser'
GO

EXECUTE [State].[Proc1];
REVERT
GO

SELECT SYSTEM_USER AS CurrentLogin, 
CURRENT_USER AS CurrentUser;
GO