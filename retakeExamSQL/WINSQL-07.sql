USE [master];
GO
ALTER DATABASE [ExamDB] SET READ_COMMITTED_SNAPSHOT OFF
WITH ROLLBACK IMMEDIATE;


/* 
    Version: v3
	
	Az alábbi lekérdezések futtatásához 2 lekérdezési ablakot (session) használj párhuzamosan! 
*/
/*Elsõ ablak:

/* 1. ablak */
USE ExamDB;
GO

-- 1. lépés
BEGIN TRAN; 
UPDATE dbo.ExamLefty SET Numbers = Numbers + 1;
GO

-- 3. lépés
SELECT * FROM dbo.ExamLefty;
GO
*/

SELECT @@SPID

/*Másik ablak:

/* 2. ablak */
USE ExamDB;
GO

-- 2. lépés
BEGIN TRAN; 
UPDATE dbo.ExamRighty SET Numbers = Numbers + 1;
GO

-- 4. lépés
SELECT * FROM dbo.ExamRighty;
GO
*/

USE [ExamDB]
GO

SELECT @@TRANCOUNT

SELECT * FROM sys.dm_tran_locks;

SELECT * FROM sys.dm_os_waiting_tasks
WHERE session_id = 59
OR session_id = 76;
GO

/*


EXEC sp_BlitzLock; 


USE Master
GO
SELECT * 
FROM sys.dm_exec_requests
WHERE 59 <> 0;
GO

USE Master
GO
SELECT session_id, wait_duration_ms, wait_type, blocking_session_id 
FROM sys.dm_os_waiting_tasks 
WHERE 59 <> 0
GO

USE Master
GO
SELECT * FROM sys.dm_tran_locks
WHERE request_session_id = 59
OR request_session_id = 76;
GO

SELECT resource_type, request_mode, resource_description
FROM sys.dm_tran_locks
WHERE resource_type <> 'ExamDB';

*/

