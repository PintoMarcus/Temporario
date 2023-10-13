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
-- USANDO a Postgres

DO $$ 
DECLARE
    table_record record;
    total_size_bytes bigint;
BEGIN
    RAISE NOTICE 'Tabela | NumeroDeLinhas | EspacoTotalKB | EspacoUsadoKB | EspacoLivreKB | EspacoUsadoPorDadosKB | EspacoUsadoPorIndicesKB';

    FOR table_record IN (SELECT schemaname, tablename FROM pg_tables WHERE schemaname NOT LIKE 'pg_%' AND schemaname != 'information_schema') 
    LOOP
        EXECUTE FORMAT('SELECT COUNT(*) FROM %I.%I', table_record.schemaname, table_record.tablename) INTO table_record.NumeroDeLinhas;

        EXECUTE FORMAT('SELECT pg_size_pretty(pg_total_relation_size(%I.%I))', table_record.schemaname, table_record.tablename) INTO total_size_bytes;
        table_record.EspacoTotalKB := total_size_bytes / 1024;

        EXECUTE FORMAT('SELECT pg_size_pretty(pg_size_pretty(pg_total_relation_size(%I.%I) - pg_relation_size(%I.%I)))', table_record.schemaname, table_record.tablename, table_record.schemaname, table_record.tablename) INTO table_record.EspacoLivreKB;

        EXECUTE FORMAT('SELECT pg_size_pretty(pg_size_pretty(pg_relation_size(%I.%I)))', table_record.schemaname, table_record.tablename) INTO table_record.EspacoUsadoKB;

        EXECUTE FORMAT('SELECT pg_size_pretty(pg_size_pretty(pg_total_relation_size(%I.%I) - pg_relation_size(%I.%I) + pg_indexes_size(%I.%I)))', table_record.schemaname, table_record.tablename, table_record.schemaname, table_record.tablename, table_record.schemaname, table_record.tablename) INTO table_record.EspacoUsadoPorDadosKB;

        EXECUTE FORMAT('SELECT pg_size_pretty(pg_indexes_size(%I.%I))', table_record.schemaname, table_record.tablename) INTO table_record.EspacoUsadoPorIndicesKB;

        RAISE NOTICE '% | % | % | % | % | % | %',
                     table_record.schemaname || '.' || table_record.tablename,
                     table_record.NumeroDeLinhas,
                     table_record.EspacoTotalKB,
                     table_record.EspacoUsadoKB,
                     table_record.EspacoLivreKB,
                     table_record.EspacoUsadoPorDadosKB,
                     table_record.EspacoUsadoPorIndicesKB;
    END LOOP;
END $$;
