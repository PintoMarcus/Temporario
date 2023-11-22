USE YourDatabaseName;

SELECT 
    OBJECT_NAME(object_id) AS ProcedureName,
    last_execution_time
FROM 
    sys.dm_exec_procedure_stats
WHERE 
    OBJECT_NAME(object_id) = 'prc_001'
    AND database_id = DB_ID('YourDatabaseName')
ORDER BY 
    last_execution_time DESC;
