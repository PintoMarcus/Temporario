SELECT
    CONVERT(datetime2, FORMAT(A.dtcoleta, 'yyyy-MM-dd HH:mm')) AS dtcoleta,
    B.DBName,
    B.CPUPercent AS SQL_CPUPercent,
    A.cpu_sql * (B.CPUPercent / 100) AS TotalCpuPercent
FROM
    [dbo].[tbx44_base_sql_cpu] AS A
INNER JOIN
    [dbo].[tbx44_base_sql_cpu_database] AS B ON CONVERT(datetime2, FORMAT(A.dtcoleta, 'yyyy-MM-dd HH:mm')) = CONVERT(datetime2, FORMAT(B.dtcoleta, 'yyyy-MM-dd HH:mm'));
