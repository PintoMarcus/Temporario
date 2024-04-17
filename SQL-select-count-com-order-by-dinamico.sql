-- SCRIPT QUE GERA SELECT TOP 100 * FROM MINHA TABELA ORDER BY X,Y,Z ... DE ACORDO COM A QUANTIDADE DE COLUNAS.

SELECT  'SELECT TOP 100 * FROM ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) +
               ' ORDER BY ' + STUFF((SELECT ',' + CAST(ORDINAL_POSITION AS VARCHAR(10))
                                     FROM information_schema.columns 
                                     WHERE TABLE_SCHEMA = t.TABLE_SCHEMA 
                                       AND TABLE_NAME = t.TABLE_NAME 
                                     ORDER BY ORDINAL_POSITION
                                     FOR XML PATH('')), 1, 1, '') + ';' + CHAR(13)
FROM information_schema.tables t
WHERE TABLE_TYPE = 'BASE TABLE'
