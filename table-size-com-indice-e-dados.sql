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
-- Crie uma tabela temporária para armazenar os resultados
CREATE TABLE #TableSizes
(
    TableName NVARCHAR(128),
    RowCount INT,
    ReservedSize VARCHAR(50),
    DataSize VARCHAR(50),
    IndexSize VARCHAR(50),
    UnusedSize VARCHAR(50)
)

-- Declare variáveis para conter o nome das tabelas
DECLARE @TableName NVARCHAR(128)

-- Declare um cursor para percorrer as tabelas
DECLARE tableCursor CURSOR FOR
SELECT name
FROM sys.tables

-- Itera pelas tabelas
OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO #TableSizes
    EXEC sp_spaceused @TableName

    FETCH NEXT FROM tableCursor INTO @TableName
END

-- Fecha o cursor
CLOSE tableCursor
DEALLOCATE tableCursor

-- Seleciona os resultados
SELECT
    TableName AS 'Nome da Tabela',
    RowCount AS 'Número de Linhas',
    DataSize AS 'Tamanho dos Dados',
    IndexSize AS 'Tamanho dos Índices'
FROM #TableSizes

-- Limpa a tabela temporária
DROP TABLE #TableSizes
