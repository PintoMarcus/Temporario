SELECT * 
FROM sys.index_columns
WHERE object_id = OBJECT_ID('NomeDaTabela');



SELECT * 
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('NomeDaTabela'), NULL, NULL, 'DETAILED');



SELECT * 
FROM sys.dm_db_index_usage_stats
WHERE object_id = OBJECT_ID('NomeDaTabela');



SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    i.name AS IndexName,
    c.name AS ColumnName,
    ic.key_ordinal,
    i.type_desc
FROM 
    sys.indexes i
    JOIN sys.tables t ON i.object_id = t.object_id
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE 
    t.name = 'NomeDaTabela'
ORDER BY 
    s.name, t.name, i.name, ic.key_ordinal;




SELECT * 
FROM sys.partitions
WHERE object_id = OBJECT_ID('NomeDaTabela');




SELECT 
    s.name AS StatsName,
    c.name AS ColumnName
FROM 
    sys.stats s
    JOIN sys.stats_columns sc ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id
    JOIN sys.columns c ON sc.object_id = c.object_id AND sc.column_id = c.column_id
WHERE 
    s.object_id = OBJECT_ID('NomeDaTabela');



