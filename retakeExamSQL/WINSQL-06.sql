USE [master]
GO

RESTORE HEADERONLY   
FROM 
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\RestoreDB_Full.bak' ;  
GO  
RESTORE HEADERONLY   
FROM 
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\RestoreDB_Diff_4.bak' ;  
GO

RESTORE DATABASE [RestoreDB] FROM  
DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\RestoreDB_Full' WITH  FILE = 1,  NOUNLOAD,  STATS = 5
GO

RESTORE LOG [RestoreDB] FROM DISK = 'RestoreDB_Log_2.trn' WITH NORECOVERY
RESTORE LOG [RestoreDB] FROM DISK = 'RestoreDB_Log_3.trn' WITH NORECOVERY 
RESTORE LOG [RestoreDB] FROM DISK = 'RestoreDB_Log_6.trn' WITH NORECOVERY 
RESTORE LOG [RestoreDB] FROM DISK = 'RestoreDB_Log_5.trn' WITH NORECOVERY 


SELECT 
    GETDATE() AS [examstimestamp], 
    @@SERVERNAME AS [myservername],
    * 
FROM dbo.RestoreTable;

BACKUP DATABASE [SampleDB] TO  DISK = N'E:\DBbackup\SampleDB2.bak' WITH NOFORMAT, INIT,  NAME = N'SampleDB-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10, CHECKSUM
GO
 
WAITFOR DELAY '00:01:00.000'
BACKUP LOG [SampleDB] TO  DISK = N'E:\DBbackup\SampleDB9.trn' WITH NOFORMAT, INIT, 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO