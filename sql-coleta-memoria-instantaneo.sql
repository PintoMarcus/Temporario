SELECT getdate() AS DataColeta
     , @@servername AS ServerName
     , ISNULL(DB_NAME(database_id), 'ResourceDb') AS DatabaseName
     , CAST(COUNT(row_count) * 8.0 / (1024.0) AS DECIMAL(28,2)) AS Tamanho_em_MB
     , CAST(CAST(SUM(CAST(free_space_in_bytes AS BIGINT)) AS DECIMAL) / (1024 * 1024) AS DECIMAL(20,2))  AS Livre_em_MB
     , CAST(( (CAST(CAST(SUM(CAST(free_space_in_bytes AS BIGINT)) AS DECIMAL) / (1024 * 1024) AS DECIMAL(20,2))) 
              / 
              NULLIF( (CAST(COUNT(row_count) * 8.0 / (1024.0) AS DECIMAL(28,2))) , 0)) * 100 AS DECIMAL(5,2)) AS Free_Percent
  FROM sys.dm_os_buffer_descriptors
 GROUP BY database_id
ORDER BY DatabaseName








with ctesizeDB as	(							
SELECT		'DB:' +DB_NAME (database_id) AS cDBName,
		cast(COUNT(*)*8/1024	as decimal(13,2)) AS nSizeInMemoryMB
FROM sys.dm_os_buffer_descriptors 
GROUP BY DB_NAME(database_id) 
union all								
select	'Mem:' +type ,sum(pages_kb + 0)/1024					
from sys.dm_os_memory_clerks

where 
type <> 'MEMORYCLERK_SQLBUFFERPOOL'
 group by type
)
select * 
from cteSizeDB 
where nSizeInMemoryMB > 0
union								
select	'Todos',SUM (nSizeInMemoryMB)			
from cteSizeDB								
order by	2			desc;	



---- COLETA DE INFORMAÇÃO MAX MEMORY DA INSTÂNCIA
-- Consulta para obter o nome da instância e o valor máximo de memória configurado em GB
SELECT @@SERVERNAME AS InstanceName,
       CAST((CAST(value_in_use AS FLOAT) / 1024) AS DECIMAL(10, 2)) AS MaxMemoryGB
FROM sys.configurations
WHERE name = 'max server memory (MB)';


--- Coleta memória do servidor e memória da instância

SELECT 
    CEILING(physical_memory_kb / 1024.0 / 1024.0) AS server_hardware_memory_gb,
    CONVERT(INT, value_in_use) / 1024 AS instance_max_memory_configured_gb
FROM 
    sys.dm_os_sys_info
CROSS JOIN
    (SELECT value_in_use 
     FROM sys.configurations 
     WHERE name = 'max server memory (MB)') AS config;
