USE ExamDB
GO

ALTER DATABASE ExamDB
SET COMPATIBILITY_LEVEL = 150;  
GO

SET STATISTICS IO ON;  
GO

IF NOT EXISTS 
(SELECT name FROM sysindexes 
WHERE name = 'idx_name_lastRecPop')

CREATE INDEX [idx_name_lastRecPop] 
ON dbo.ExamCities ([CityName]) INCLUDE ([LatestRecordedPopulation]);
GO
SELECT CityName, LatestRecordedPopulation 
FROM dbo.ExamCities 
WHERE CityName LIKE 'A%'; 
GO

SELECT CityName, LatestRecordedPopulation 
FROM dbo.ExamCities WHERE CityName = 'Albany';
GO

