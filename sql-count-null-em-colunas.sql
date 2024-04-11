-- Script percorre todas as tabelas e colunas
-- Criar uma tabela temporária para armazenar os resultados
CREATE TABLE #Resultado (
    Schema_Tabela NVARCHAR(100),
    Nome_Tabela NVARCHAR(100),
    Coluna_Tabela NVARCHAR(100),
    Count_Resultado INT
);

DECLARE @Tabela NVARCHAR(100);
DECLARE @Schema NVARCHAR(100);
DECLARE @Coluna NVARCHAR(100);
DECLARE @SQL NVARCHAR(MAX);

-- Cursor para percorrer todas as tabelas e colunas
DECLARE cur CURSOR FOR
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;

OPEN cur;

FETCH NEXT FROM cur INTO @Schema, @Tabela, @Coluna;

-- Loop através das tabelas e colunas
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Gerar a consulta dinâmica para contar os registros nulos
    SET @SQL = '
        INSERT INTO #Resultado (Schema_Tabela, Nome_Tabela, Coluna_Tabela, Count_Resultado)
        SELECT ''' + @Schema + ''', ''' + @Tabela + ''', ''' + @Coluna + ''', COUNT(*)
        FROM ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@Tabela) + '
        WHERE ' + QUOTENAME(@Coluna) + ' IS NULL;
    ';

    -- Executar a consulta dinâmica
    EXEC sp_executesql @SQL;

    FETCH NEXT FROM cur INTO @Schema, @Tabela, @Coluna;
END

CLOSE cur;
DEALLOCATE cur;

-- Retornar os resultados apenas das colunas que possuem valores nulos
SELECT *
FROM #Resultado where Count_Resultado > 0;

-- Retornar os resultados total
/*
SELECT *
FROM #Resultado;
*/
-- Limpar a tabela temporária
DROP TABLE #Resultado;
