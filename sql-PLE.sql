-- Consulta para obter o "Page Life Expectancy" (PLE)
SELECT 
    [object_name] AS 'Nome do Objeto',
    cntr_value AS 'Page Life Expectancy (segundos)',
    cntr_value / 60.0 AS 'Page Life Expectancy (minutos)',
    cntr_value / 3600.0 AS 'Page Life Expectancy (horas)',
    cntr_value / 86400.0 AS 'Page Life Expectancy (dias)'
FROM sys.dm_os_performance_counters
WHERE 
    [counter_name] = 'Page life expectancy'
    AND [object_name] LIKE '%Buffer Manager%';
