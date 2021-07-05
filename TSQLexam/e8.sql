/*
Exercise #8:
Create the following table:
DROP TABLE IF EXISTS Application.LogAudit;
GO
CREATE TABLE Application.LogAudit
(
    LogAuditId int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    LogData nvarchar(50) NOT NULL
);
Create a stored procedure in the Application schema named InsertLogData.
The stored procedure inserts a new record into the Application.LogAudit table.
The stored procedure should accept the mandatory columns as parameters:
•	@logdata nvarchar(50)
Use error handling and error handling functions to display the error number and the error message!
If the insert is successful, return the newly inserted LogAuditId value as a return value.
If an error occurs, handle the error:
•	print: 'Insert of log audit failed!'
•	print: 'Error number: ' and the error number
•	print: 'Error message: ' and the error message
•	return -1 as a return value
Showcase how you use the stored procedure!

*/

DROP TABLE IF EXISTS Application.LogAudit;
GO
CREATE TABLE Application.LogAudit
(
    LogAuditId int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    LogData nvarchar(50) NOT NULL
);

DROP PROCEDURE IF EXISTS Application.InsertLogData;
GO
CREATE PROCEDURE Application.InsertLogData
    @logdata AS nvarchar(50)
AS
BEGIN
    BEGIN TRY
        INSERT INTO Application.LogAudit(LogData)
        VALUES                          (@logdata);

        RETURN (SELECT IDENT_CURRENT(Application.LogAudit.LogAuditId));
    END TRY
    BEGIN CATCH
        PRINT 'Insert of log audit failed!';
        PRINT CONCAT('Error number:',  ERROR_NUMBER());
        PRINT CONCAT('Error message:', ERROR_MESSAGE());

        RETURN (SELECT -1);
    END CATCH
END
GO

EXECUTE Application.InsertLogData 'Hello';