-- script de exemplo para trazer as tabelas que cont�m colunas com acentua��o e espa�o nos nomes
-- traz tramb�m as tabelas, procedures e views com nomes que cont�m acento ou espa�os em branco.

use [meu banco];
SELECT 
    COLUMN_NAME AS NomeObjeto,
    'Coluna' AS Tipo,
    TABLE_NAME AS Tabela
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
    COLUMN_NAME COLLATE Latin1_General_BIN LIKE '%[^a-zA-Z0-9_]%'
  --  OR TABLE_NAME COLLATE Latin1_General_BIN LIKE '%[^a-zA-Z0-9_]%'

union all
SELECT distinct
    TABLE_NAME AS NomeObjeto,
    'TABELA' AS Tipo,
    TABLE_NAME AS Tabela
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
   -- COLUMN_NAME COLLATE Latin1_General_BIN LIKE '%[^a-zA-Z0-9_]%'
  TABLE_NAME COLLATE Latin1_General_BIN LIKE '%[^a-zA-Z0-9_]%'
ORDER BY tipo, Tabela, NomeObjeto


-- views
SELECT 
    TABLE_NAME AS NomeObjeto,
    'Visualiza��o' AS Tipo
FROM INFORMATION_SCHEMA.VIEWS
WHERE 
    TABLE_NAME COLLATE Latin1_General_BIN LIKE '%[^a-zA-Z0-9_]%'
union all

-- procedures
SELECT 
    ROUTINE_NAME AS NomeObjeto,
    'Procedimento Armazenado' AS Tipo
FROM INFORMATION_SCHEMA.ROUTINES
WHERE 
    ROUTINE_NAME COLLATE Latin1_General_BIN LIKE '%[^a-zA-Z0-9_]%'
ORDER BY tipo, NomeObjeto;
