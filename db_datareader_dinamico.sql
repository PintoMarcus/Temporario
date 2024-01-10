DECLARE @DatabaseName NVARCHAR(255) = 'my_db';
DECLARE @RoleName NVARCHAR(255) = 'db_datareader';
DECLARE @SchemaName NVARCHAR(255);
DECLARE @TableName NVARCHAR(255);
DECLARE @GrantStatement NVARCHAR(MAX);

-- Verifica se a role db_datareader existe, se não existir, cria
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @RoleName AND type = 'R')
BEGIN
    --EXEC('CREATE ROLE ' + QUOTENAME(@RoleName));
    --EXEC('CREATE ROLE ' + @RoleName);
    PRINT 'Role ' + @RoleName + ' criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'Role ' + @RoleName + ' já existe.';
END

-- Cursor para percorrer todas as tabelas do banco de dados
DECLARE tableCursor CURSOR FOR
SELECT 
    schema_name(schema_id) AS SchemaName,
    name AS TableName
FROM 
    sys.tables;

-- Variável temporária para armazenar a declaração do comando GRANT
CREATE TABLE #GrantCommands (Command NVARCHAR(MAX));

OPEN tableCursor;
FETCH NEXT FROM tableCursor INTO @SchemaName, @TableName;

-- Loop através das tabelas
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Gera o comando GRANT
    SET @GrantStatement = 
        'GRANT SELECT ON ' + QUOTENAME(@DatabaseName) + '.' + 
        QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' TO ' + QUOTENAME(@RoleName);

    -- Insere o comando na tabela temporária
    INSERT INTO #GrantCommands (Command) VALUES (@GrantStatement);

    FETCH NEXT FROM tableCursor INTO @SchemaName, @TableName;
END

CLOSE tableCursor;
DEALLOCATE tableCursor;

-- Executa os comandos GRANT dinâmicos
DECLARE @Command NVARCHAR(MAX);
DECLARE grantCursor CURSOR FOR
SELECT Command FROM #GrantCommands;

OPEN grantCursor;
FETCH NEXT FROM grantCursor INTO @Command;

-- Loop através dos comandos
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC sp_executesql @Command;

    FETCH NEXT FROM grantCursor INTO @Command;
END

CLOSE grantCursor;
DEALLOCATE grantCursor;

-- Limpa a tabela temporária
DROP TABLE #GrantCommands;




/* +++++++++++++++++++++++++++++ */
-- usando while: tentativa 01

DECLARE @DatabaseName NVARCHAR(255) = 'my_db';
DECLARE @RoleName NVARCHAR(255) = 'db_datareader';
DECLARE @SchemaName NVARCHAR(255);
DECLARE @TableName NVARCHAR(255);
DECLARE @GrantStatement NVARCHAR(MAX);
DECLARE @Counter INT = 1;
DECLARE @MaxCounter INT;

-- Verifica se a role db_datareader existe, se não existir, cria
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @RoleName AND type = 'R')
BEGIN
    --EXEC('CREATE ROLE ' + QUOTENAME(@RoleName));
    --EXEC('CREATE ROLE ' + @RoleName);
    PRINT 'Role ' + @RoleName + ' criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'Role ' + @RoleName + ' já existe.';
END

-- Obter o número total de tabelas
SELECT @MaxCounter = COUNT(*)
FROM sys.tables;

-- Loop através das tabelas
WHILE @Counter <= @MaxCounter
BEGIN
    -- Obter o nome do esquema e da tabela
    SELECT 
        @SchemaName = schema_name(schema_id),
        @TableName = name
    FROM 
        sys.tables
    WHERE
        object_id = @Counter;

    -- Gera o comando GRANT
    SET @GrantStatement = 
        'GRANT SELECT ON ' + QUOTENAME(@DatabaseName) + '.' + 
        QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' TO ' + QUOTENAME(@RoleName);

    -- Executa o comando GRANT
    EXEC sp_executesql @GrantStatement;

    -- Incrementa o contador
    SET @Counter = @Counter + 1;
END;



/**********************************************************************************/
-- usando while tentativa 02
DECLARE @DatabaseName NVARCHAR(255) = 'my_db';
DECLARE @RoleName NVARCHAR(255) = 'db_datareader';
DECLARE @SchemaName NVARCHAR(255);
DECLARE @TableName NVARCHAR(255);
DECLARE @GrantStatement NVARCHAR(MAX);
DECLARE @Counter INT = 1;
DECLARE @MaxCounter INT;

-- Verifica se a role db_datareader existe, se não existir, cria
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @RoleName AND type = 'R')
BEGIN
    --EXEC('CREATE ROLE ' + QUOTENAME(@RoleName));
    --EXEC('CREATE ROLE ' + @RoleName);
    PRINT 'Role ' + @RoleName + ' criada com sucesso.';
END
ELSE
BEGIN
    PRINT 'Role ' + @RoleName + ' já existe.';
END

-- Obter o número total de tabelas
SELECT @MaxCounter = COUNT(*)
FROM sys.tables;

-- Loop através das tabelas
WHILE @Counter <= @MaxCounter
BEGIN
    -- Obter o nome do esquema e da tabela
    SELECT 
        @SchemaName = SCHEMA_NAME(schema_id),
        @TableName = name
    FROM 
        sys.tables
    WHERE
        object_id = OBJECT_ID(QUOTENAME(@DatabaseName) + '.' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name));

    -- Gera o comando GRANT
    SET @GrantStatement = 
        'GRANT SELECT ON ' + QUOTENAME(@DatabaseName) + '.' + 
        QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' TO ' + QUOTENAME(@RoleName);

    -- Executa o comando GRANT
    EXEC sp_executesql @GrantStatement;

    -- Incrementa o contador
    SET @Counter = @Counter + 1;
END;

