USE SeuBancoDeDados; -- Substitua pelo nome do seu banco de dados
GO

DECLARE @Tabela NVARCHAR(128) = 'SuaTabela'; -- Substitua pelo nome da sua tabela

-- Obter informações do espaço da tabela
DBCC UPDATEUSAGE (0); -- Atualiza as informações de uso do banco de dados
SELECT 
    t.NAME AS TableName,
    p.rows AS NumeroDeLinhas,
    SUM(a.total_pages) * 8 AS EspacoTotalKB,
    SUM(a.used_pages) * 8 AS EspacoUsadoKB,
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS EspacoLivreKB,
    SUM(CASE WHEN i.index_id <= 1 THEN a.used_pages ELSE 0 END) * 8 AS EspacoUsadoPorDadosKB,
    SUM(CASE WHEN i.index_id > 1 THEN a.used_pages ELSE 0 END) * 8 AS EspacoUsadoPorIndicesKB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.OBJECT_ID
INNER JOIN sys.partitions p ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE t.NAME = @Tabela
GROUP BY t.NAME, p.rows;


/*++++++++++++++++++++++++*/
-- USANDO a PORTA do BABELFISH
SELECT
    t.name AS TableName,
    SUM(p.rows) AS NumeroDeLinhas,
    SUM(s.total_pages * 8) AS EspacoTotalKB
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
INNER JOIN sys.dm_db_partition_stats s ON t.object_id = s.object_id AND p.index_id = s.index_id
GROUP BY t.name;

