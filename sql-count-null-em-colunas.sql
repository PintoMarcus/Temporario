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
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME NOT IN (SELECT Nome_Tabela FROM @TabelasParaIgnorar)
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
FROM #Resultado WHERE Count_Resultado > 0;


-- Retornar os resultados total
/*
SELECT *
FROM #Resultado;
*/
-- Limpar a tabela temporária
DROP TABLE #Resultado;
