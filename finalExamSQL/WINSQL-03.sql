USE [master]
GO

CREATE LOGIN [ExamLogin] 
WITH PASSWORD=N'Zylo123' 
MUST_CHANGE, DEFAULT_DATABASE=[WideWorldImporters], 
CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

USE [WideWorldImporters]
GO

CREATE USER [ExamUser] FOR LOGIN [ExamLogin]

ALTER AUTHORIZATION ON SCHEMA::[db_datawriter] TO [ExamUser]

ALTER AUTHORIZATION ON SCHEMA::[Warehouse] TO [ExamUser]

ALTER ROLE [db_datawriter] ADD MEMBER [ExamUser]

GRANT DELETE ON [Warehouse].[ColdRoomTemperatures] TO [ExamUser]

GRANT INSERT ON [Warehouse].[ColdRoomTemperatures] TO [ExamUser]

GRANT SELECT ON [Warehouse].[ColdRoomTemperatures] TO [ExamUser]

GRANT UPDATE ON [Warehouse].[ColdRoomTemperatures] TO [ExamUser]
GO

SELECT [ColorName] FROM Warehouse.Colors;   
EXECUTE AS USER = 'ExamUser';  
GO  
SELECT CURRENT_USER;  
GO  
REVERT;  
GO  
SELECT CURRENT_USER;  
GO


