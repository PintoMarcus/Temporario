-- Obter o tamanho dos índices em um banco de dados
SELECT 
    OBJECT_NAME(p.[object_id]) AS TableName,
    i.name AS IndexName,
    SUM(ps.[used_page_count]) * 8 AS IndexSizeKB
FROM sys.dm_db_partition_stats AS ps
INNER JOIN sys.indexes AS i ON ps.[object_id] = i.[object_id] AND ps.[index_id] = i.[index_id]
INNER JOIN sys.partitions AS p ON ps.[partition_id] = p.[partition_id]
WHERE ps.[index_id] > 0 -- Excluir o índice de heap
GROUP BY OBJECT_NAME(p.[object_id]), i.name
ORDER BY TableName, IndexName;
