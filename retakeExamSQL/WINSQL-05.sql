USE [ExamDB]
GO

EXEC sys.sp_configure N'backup compression default', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO

ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 1;
GO

SELECT name, description, value, is_advanced  
FROM sys.configurations;   
GO

SELECT *  
FROM sys.configurations
WHERE [name] = 'backup compression default' OR 
[name] = 'max degree of parallelism';   
GO 

ALTER DATABASE [ExamDB] SET QUERY_STORE = ON
GO

ALTER DATABASE [ExamDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, MAX_STORAGE_SIZE_MB = 500, QUERY_CAPTURE_MODE = ALL)
GO

