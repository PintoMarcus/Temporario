SELECT
    CONVERT(datetime2, FORMAT(A.dtcoleta, 'yyyy-MM-dd HH:mm')) AS dtcoleta,
    B.DBName,
    B.CPUPercent AS SQL_CPUPercent,
    A.cpu_sql * (B.CPUPercent / 100) AS TotalCpuPercent
FROM
    [dbo].[tbx44_base_sql_cpu] AS A
INNER JOIN
    [dbo].[tbx44_base_sql_cpu_database] AS B ON CONVERT(datetime2, FORMAT(A.dtcoleta, 'yyyy-MM-dd HH:mm')) = CONVERT(datetime2, FORMAT(B.dtcoleta, 'yyyy-MM-dd HH:mm'));


*************************
    -- 2008
SELECT
    CONVERT(datetime, CONVERT(varchar(16), A.dtcoleta, 120) + ':00') AS dtcoleta,
    B.DBName,
    B.CPUPercent AS SQL_CPUPercent,
    A.cpu_sql * (B.CPUPercent / 100) AS TotalCpuPercent
FROM
    [dbo].[tbx44_base_sql_cpu] AS A
INNER JOIN
    [dbo].[tbx44_base_sql_cpu_database] AS B ON DATEADD(MINUTE, DATEDIFF(MINUTE, 0, A.dtcoleta), 0) = DATEADD(MINUTE, DATEDIFF(MINUTE, 0, B.dtcoleta), 0);


**********************

SELECT
    runtime,
    database_name,
    allocated_memory_gb,
    CASE 
        WHEN DATEPART(WEEKDAY, runtime) BETWEEN 2 AND 6 -- Segunda a Sexta (2 a 6)
        AND CAST(runtime AS TIME) BETWEEN '07:00:00.000' AND '21:00:00.000' -- Horário comercial
        THEN 'Sim'
        ELSE 'Não'
    END AS [hora-comercial]
FROM contador_memoria;


-- versão 2008
SELECT
    runtime,
    database_name,
    allocated_memory_gb,
    CASE 
        WHEN DATEPART(WEEKDAY, runtime) BETWEEN 2 AND 6 -- Segunda a Sexta (2 a 6)
            AND CONVERT(TIME, runtime) BETWEEN '07:00:00' AND '21:00:00' -- Horário comercial
            THEN 'Sim'
        ELSE 'Não'
    END AS [hora-comercial]
FROM contador_memoria;

