WITH FilteredData AS (
    SELECT
        datacoleta,
        sql_cpu,
        idle_cpu,
        other_cpu
    FROM
        uso_cpu
    WHERE
        datacoleta >= DATEADD(DAY, -60, GETDATE())
),
GroupedData AS (
    SELECT
        CASE
            WHEN DATEPART(HOUR, datacoleta) BETWEEN 0 AND 5 THEN '00:00:00-05:59:59'
            WHEN DATEPART(HOUR, datacoleta) BETWEEN 6 AND 11 THEN '06:00:00-11:59:59'
            WHEN DATEPART(HOUR, datacoleta) BETWEEN 12 AND 17 THEN '12:00:00-17:59:59'
            WHEN DATEPART(HOUR, datacoleta) BETWEEN 18 AND 23 THEN '18:00:00-23:59:59'
        END AS TimeGroup,
        sql_cpu,
        idle_cpu,
        other_cpu
    FROM
        FilteredData
)
SELECT
    TimeGroup,
    MIN(sql_cpu) AS MinSQLCPU,
    MAX(sql_cpu) AS MaxSQLCPU,
    AVG(sql_cpu) AS AvgSQLCPU,
    MIN(idle_cpu) AS MinIdleCPU,
    MAX(idle_cpu) AS MaxIdleCPU,
    AVG(idle_cpu) AS AvgIdleCPU,
    MIN(other_cpu) AS MinOtherCPU,
    MAX(other_cpu) AS MaxOtherCPU,
    AVG(other_cpu) AS AvgOtherCPU
FROM
    GroupedData
GROUP BY
    TimeGroup
ORDER BY
    CASE 
        WHEN TimeGroup = '00:00:00-05:59:59' THEN 1
        WHEN TimeGroup = '06:00:00-11:59:59' THEN 2
        WHEN TimeGroup = '12:00:00-17:59:59' THEN 3
        WHEN TimeGroup = '18:00:00-23:59:59' THEN 4
    END;




/**********************************- EXEMPLO 002 **************************************/
DECLARE @total_cores_server INT = 8; -- Ajuste para o número total de cores do seu servidor

WITH FilteredData AS (
    SELECT
        A.dtcoleta AS DtColetaA,
        B.dtcoleta AS DtColetaB,
        B.DBName,
        A.cpu_sql,
        B.CPUPercent
    FROM
        [sch].[_sql_cpu] AS A
    JOIN
        [sch].[_sql_cpu_database] AS B
        ON DATEADD(MINUTE, DATEDIFF(MINUTE, 0, A.dtcoleta), 0) = DATEADD(MINUTE, DATEDIFF(MINUTE, 0, B.dtcoleta), 0)
    WHERE
        B.DtCoIeta >= DATEADD(DAY, -60, GETDATE())
        AND B.DBName NOT IN ('tempdb')
),
GroupedData AS (
    SELECT
        DBName,
        CASE
            WHEN DATEPART(HOUR, DtColetaB) BETWEEN 0 AND 5 THEN '00:00:00-05:59:59'
            WHEN DATEPART(HOUR, DtColetaB) BETWEEN 6 AND 11 THEN '06:00:00-11:59:59'
            WHEN DATEPART(HOUR, DtColetaB) BETWEEN 12 AND 17 THEN '12:00:00-17:59:59'
            WHEN DATEPART(HOUR, DtColetaB) BETWEEN 18 AND 23 THEN '18:00:00-23:59:59'
        END AS TimeGroup,
        A.cpu_sql * (B.CPUPercent / 100.0) AS CpuPercent,
        (A.cpu_sql * (B.CPUPercent / 100.0)) / 100.0 * @total_cores_server AS TotalCores
    FROM
        FilteredData
)
SELECT
    DBName,
    TimeGroup,
    AVG(CpuPercent) AS AVGCpuPercent,
    MAX(CpuPercent) AS MAXCpuPercent,
    AVG(TotalCores) AS AVGTotalCores,
    MAX(TotalCores) AS MAXTotalCores
FROM
    GroupedData
GROUP BY
    DBName, TimeGroup
ORDER BY
    DBName,
    CASE 
        WHEN TimeGroup = '00:00:00-05:59:59' THEN 1
        WHEN TimeGroup = '06:00:00-11:59:59' THEN 2
        WHEN TimeGroup = '12:00:00-17:59:59' THEN 3
        WHEN TimeGroup = '18:00:00-23:59:59' THEN 4
    END;
