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



/********************************** IO DISCO ***************************************/

WITH FilteredData AS (
    SELECT
        dbname,
        dbfile,
        num_of_writes,
        MB_written,
        num_of_reads,
        MB_read,
        latency_read_ms,
        latency_write_ms,
        DtColeta,
        CASE
            WHEN DATEPART(HOUR, DtColeta) BETWEEN 0 AND 5 THEN '00:00:00-05:59:59'
            WHEN DATEPART(HOUR, DtColeta) BETWEEN 6 AND 11 THEN '06:00:00-11:59:59'
            WHEN DATEPART(HOUR, DtColeta) BETWEEN 12 AND 17 THEN '12:00:00-17:59:59'
            WHEN DATEPART(HOUR, DtColeta) BETWEEN 18 AND 23 THEN '18:00:00-23:59:59'
        END AS TimeGroup
    FROM
        [shc].[_sql_disk]
    WHERE
        DBNAME IN ('tempdb')
        AND (num_of_writes >= 0 OR num_of_reads >= 0)
        AND DtColeta >= DATEADD(DAY, -10, GETDATE())
),
AggregatedData AS (
    SELECT
        dbname,
        TimeGroup,
        CASE
            WHEN dbfile LIKE '%.mdf' OR dbfile LIKE '%.ndf' THEN 'Datafile'
            WHEN dbfile LIKE '%.ldf' THEN 'LogFile'
            ELSE dbfile
        END AS TipoArquivo,
        MAX(num_of_writes) AS max_writes,
        MAX(MB_written) AS max_mb_written,
        MAX(num_of_reads) AS max_reads,
        MAX(MB_read) AS max_mb_read,
        MAX(latency_read_ms) AS max_latency_read_ms,
        MAX(latency_write_ms) AS max_latency_write_ms,
        AVG(num_of_writes) AS avg_writes,
        AVG(MB_written) AS avg_mb_written,
        AVG(num_of_reads) AS avg_reads,
        AVG(MB_read) AS avg_mb_read,
        AVG(latency_read_ms) AS avg_latency_read_ms,
        AVG(latency_write_ms) AS avg_latency_write_ms
    FROM
        FilteredData
    GROUP BY
        dbname, dbfile, TimeGroup
)
SELECT
    dbname,
    TipoArquivo,
    TimeGroup,
    max_writes,
    max_mb_written,
    max_reads,
    max_mb_read,
    max_latency_read_ms,
    max_latency_write_ms,
    avg_writes,
    avg_mb_written,
    avg_reads,
    avg_mb_read,
    avg_latency_read_ms,
    avg_latency_write_ms
FROM
    AggregatedData
ORDER BY
    dbname,
    CASE 
        WHEN TimeGroup = '00:00:00-05:59:59' THEN 1
        WHEN TimeGroup = '06:00:00-11:59:59' THEN 2
        WHEN TimeGroup = '12:00:00-17:59:59' THEN 3
        WHEN TimeGroup = '18:00:00-23:59:59' THEN 4
    END;




/**************************************************************************************/

Falta desenvolver esse cara.
Ele é para pegar a média de cpu por dia por hora


-- Passo 1: Calcular a média de uso de CPU para cada dia dentro do intervalo de 18:00:00 a 18:59:59
WITH DailyAverage AS (
    SELECT
        CAST(datacoleta AS DATE) AS Date, -- Extrai a data sem a hora
        AVG(usocpu) AS AvgCPU
    FROM
        sua_tabela
    WHERE
        DATEPART(HOUR, datacoleta) = 18
    GROUP BY
        CAST(datacoleta AS DATE)
),

-- Passo 2: Encontrar o maior valor dessas médias diárias
MaxDailyAvg AS (
    SELECT
        MAX(AvgCPU) AS MaxAvgCPU
    FROM
        DailyAverage
)

-- Passo 3: Retornar o dia correspondente a essa média máxima
SELECT
    d.Date,
    d.AvgCPU AS MaxDailyAvgCPU
FROM
    DailyAverage d
INNER JOIN
    MaxDailyAvg m
ON
    d.AvgCPU = m.MaxAvgCPU;




/*****************************************************************************************************/

-- verificar máxima média de determinada hora
WITH FilteredData AS (
    SELECT
        a.runtime as DtColeta,
        a.cooked_value
    FROM
        MINHATABELA a
    WHERE
        a.instance_name = '_total'
),
GroupedData AS (
    SELECT
        DATEADD(HOUR, DATEPART(HOUR, DtColeta), CAST(CAST(DtColeta AS DATE) AS DATETIME)) AS HourBlock,
        DATEPART(HOUR, DtColeta) AS HourOfDay,
        CAST(DtColeta AS DATE) AS Date,
        a.cooked_value AS CpuPercent
    FROM
        FilteredData a
),
HourlyAverages AS (
    SELECT
        Date,
        HourOfDay,
        AVG(CpuPercent) AS AVGCpuPercent,
        MAX(CpuPercent) AS MAXCpuPercent
    FROM
        GroupedData
    GROUP BY
        Date,
        HourOfDay
),
MaxDailyAverages AS (
    SELECT
        HourOfDay,
        MAX(AVGCpuPercent) AS MaxAvgCpuPercent
    FROM
        HourlyAverages
    GROUP BY
        HourOfDay
)
SELECT
    HourlyAverages.Date,
    CASE HourlyAverages.HourOfDay
        WHEN 0 THEN '00-horas'
        WHEN 1 THEN '01-horas'
        WHEN 2 THEN '02-horas'
        WHEN 3 THEN '03-horas'
        WHEN 4 THEN '04-horas'
        WHEN 5 THEN '05-horas'
        WHEN 6 THEN '06-horas'
        WHEN 7 THEN '07-horas'
        WHEN 8 THEN '08-horas'
        WHEN 9 THEN '09-horas'
        WHEN 10 THEN '10-horas'
        WHEN 11 THEN '11-horas'
        WHEN 12 THEN '12-horas'
        WHEN 13 THEN '13-horas'
        WHEN 14 THEN '14-horas'
        WHEN 15 THEN '15-horas'
        WHEN 16 THEN '16-horas'
        WHEN 17 THEN '17-horas'
        WHEN 18 THEN '18-horas'
        WHEN 19 THEN '19-horas'
        WHEN 20 THEN '20-horas'
        WHEN 21 THEN '21-horas'
        WHEN 22 THEN '22-horas'
        WHEN 23 THEN '23-horas'
    END AS TimeGroup,
    HourlyAverages.AVGCpuPercent AS AVGCpuPercent,
    HourlyAverages.MAXCpuPercent AS MAXCpuPercent
FROM
    HourlyAverages
    INNER JOIN MaxDailyAverages
    ON HourlyAverages.HourOfDay = MaxDailyAverages.HourOfDay
    AND HourlyAverages.AVGCpuPercent = MaxDailyAverages.MaxAvgCpuPercent
ORDER BY
    HourlyAverages.HourOfDay;
/*********************************************************************************************************/

