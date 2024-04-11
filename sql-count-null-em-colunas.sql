-- Script percorre todas as tabelas e colunas 
-- podemos colocar as maiores tabelas em uma lista de exclusão "@TabelasParaIgnorar" para que o count seja mais rápido. 

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

-- Tabelas a serem ignoradas
DECLARE @TabelasParaIgnorar TABLE (
    Nome_Tabela NVARCHAR(100)
);

-- Adicione as tabelas que você deseja ignorar nesta tabela temporária
INSERT INTO @TabelasParaIgnorar (Nome_Tabela)
VALUES ('tabela1'), ('tabela2');

-- Cursor para percorrer todas as tabelas e colunas, excluindo as tabelas que queremos ignorar
DECLARE cur CURSOR FOR
SELECT s.name AS TABLE_SCHEMA, t.name AS TABLE_NAME, c.name AS COLUMN_NAME
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN sys.columns c ON t.object_id = c.object_id
WHERE t.type = 'U' -- Apenas tabelas (exclui views)
AND t.name NOT IN (SELECT Nome_Tabela FROM @TabelasParaIgnorar)
ORDER BY s.name, t.name, c.column_id;

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
FROM #Resultado WHERE Count_Resultado > 0;

-- Limpar a tabela temporária
DROP TABLE #Resultado;

