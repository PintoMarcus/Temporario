/* Arquivo para gerar grants
01- "GARNT SELECT, INSERT, UPDATE, DELETE ON [SCHEMA].[TABELA] TO [MINHA-ROLE];" para todas as tabelas do banco de dados x.
02 - "GRANT EXECUTE ON [SCHEMA].[FNCAO] TO [MINHA-ROLE]" para todas as funções e procedures do banco de dados x.
*/

-- Defina o nome do banco de dados e da role
DECLARE @DatabaseName NVARCHAR(128) = 'SeuBancoDeDados'
DECLARE @RoleName NVARCHAR(128) = 'SuaRole'

-- Parte 1: Gerar comandos GRANT para todas as tabelas
DECLARE @TableGrants NVARCHAR(MAX)

SET @TableGrants = ''

SELECT @TableGrants = @TableGrants + 
    'GRANT SELECT, INSERT, UPDATE, DELETE ON [' + s.name + '].[' + t.name + '] TO [' + @RoleName + '];' + CHAR(13) + CHAR(10)
FROM
    sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE
    t.type = 'U'
    AND t.is_ms_shipped = 0

PRINT @TableGrants

-- Parte 2: Gerar comandos GRANT para todas as funções e procedures
DECLARE @ProcFuncGrants NVARCHAR(MAX)

SET @ProcFuncGrants = ''

SELECT @ProcFuncGrants = @ProcFuncGrants + 
    'GRANT EXECUTE ON [' + s.name + '].[' + p.name + '] TO [' + @RoleName + '];' + CHAR(13) + CHAR(10)
FROM
    sys.objects p
    INNER JOIN sys.schemas s ON p.schema_id = s.schema_id
WHERE
    p.type IN ('P', 'FN', 'IF', 'TF') -- P: Procedures, FN: Scalar Functions, IF: Inline Table-valued Functions, TF: Table-valued Functions
    AND p.is_ms_shipped = 0

PRINT @ProcFuncGrants
