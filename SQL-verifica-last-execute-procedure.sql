SELECT 
    p.name AS ProcedureName,
    s.last_execution_time AS LastExecutionTime
FROM 
    sys.procedures AS p
JOIN 
    sys.dm_exec_procedure_stats AS s
    ON p.object_id = s.object_id
WHERE 
    p.name = 'uspGetEmployeeManagers';
