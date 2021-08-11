SELECT 
sys.databases.database_id, 
sys.databases.[name], 
recovery_model_desc,
[file_id], 
[type_desc], 
sys.master_files.[name], 
physical_database_name as [physical_name],
[size] as file_size_MB, 
is_percent_growth
FROM sys.databases
INNER JOIN
sys.master_files
ON sys.databases.database_id = sys.master_files.[file_id];