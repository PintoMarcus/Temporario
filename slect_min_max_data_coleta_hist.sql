DECLARE @sql NVARCHAR(MAX) = '';
DECLARE @schemaName NVARCHAR(128);
DECLARE @tableName NVARCHAR(128);
DECLARE @columnName NVARCHAR(128);

-- Cursor para percorrer todas as tabelas com uma coluna chamada 'data'
DECLARE table_cursor CURSOR FOR
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'data' -- Ajuste o nome da coluna
ORDER BY TABLE_SCHEMA, TABLE_NAME;

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @schemaName, @tableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Adiciona a parte da consulta para a tabela atual
    SET @sql = @sql + 
        'SELECT ''' + @tableName + ''' AS tabela, ' +
        'MIN(data) AS dt1, ' +
        'MAX(data) AS dt2 ' +
        'FROM [' + @schemaName + '].[' + @tableName + ']' + CHAR(13) + CHAR(10) +
        'UNION ALL' + CHAR(13) + CHAR(10);
        
    FETCH NEXT FROM table_cursor INTO @schemaName, @tableName;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;

-- Remover o último 'UNION ALL'
IF LEN(@sql) > 0
    SET @sql = LEFT(@sql, LEN(@sql) - 10);

-- Executar a consulta gerada
print @sql; -- printar na tela
-- EXEC sp_executesql -- executar a consulta
