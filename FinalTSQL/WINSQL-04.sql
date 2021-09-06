/*
Feladat #4:
Haszn�ld az ExamDB p�lda adatb�zist!

El�zetesen futtasd le az al�bbi script-et:
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
�rj egy T-SQL script-et ami az al�bbiakat tartalmazza:

L�trehoz egy "StateAdminLogin" nev� SQL login-t egy jelsz�val �s a ExamDB adatb�zist jel�li meg mint alap�rtelmezett adatb�zis.
*/
USE [master]
GO
CREATE LOGIN [StateAdminLogin] WITH PASSWORD=N'qweASD123' MUST_CHANGE, DEFAULT_DATABASE=[ExamDB], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

/*
L�trehoz egy "StateStudentLogin" nev� SQL login-t egy jelsz�val �s a ExamDB adatb�zist jel�li meg mint alap�rtelmezett adatb�zis.
*/
USE [master]
GO
CREATE LOGIN [StateStudentLogin] WITH PASSWORD=N'asdQWE123' MUST_CHANGE, DEFAULT_DATABASE=[ExamDB], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

/*
Az ExamDB adatb�zisban l�trehoz egy "StateAdminUser" felhaszn�l�t az el�bbi, "StateAdminLogin" login-hoz.
*/
USE [ExamDB]
GO
CREATE USER [StateAdminUser] FOR LOGIN [StateAdminLogin]
GO

/*
Az ExamDB adatb�zisban l�trehoz egy "StateStudentUser" felhaszn�l�t az el�bbi, "StateStudentLogin" login-hoz.
*/
USE [ExamDB]
GO
CREATE USER [StateStudentUser] FOR LOGIN [StateStudentLogin]
GO

/*
L�trehoz egy �j adatb�zis szerepet (role) az ExamDB adatb�zisban, "state_admin" n�ven.
*/
USE [ExamDB]
GO
CREATE ROLE [state_admin]
GO

/*
A "StateAdminUser" felhaszn�l�t hozz�adja az "state_admin" adatb�zis szerephez.
*/
USE [ExamDB]
GO
ALTER ROLE [state_admin] ADD MEMBER [StateAdminUser]
GO

/*
A "StateStudentUser" felhaszn�l�t hozz�adja egy olyan fix adatb�zis szerephez, ami megtagadja a hozz�f�r�st az adatok m�dos�t�s�ra (INSERT, UPDATE, DELETE) az ExamDB adatb�zisban.
*/
USE [ExamDB]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [StateStudentUser]
GO

/*
Az State s�m�ra EXECUTE jogot ad az "state_admin" adatb�zis szerepnek.
*/
USE [ExamDB]
GO
GRANT EXECUTE ON SCHEMA::[State] TO [state_admin]
GO

/*
Teszteli az State.Proc1 t�rolt elj�r�s futtat�s�t a "StateAdminUser" felhaszn�l� megszem�lyes�t�s�vel.
Vissza�ll�tja a v�grehajt�s kontextus�t az el�z� felhaszn�l�ra.
Lek�rdezi a jelenlegi felhaszn�l� nev�t �s a login nev�t.
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