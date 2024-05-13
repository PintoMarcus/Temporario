-- Script para criar usuários DBA nos bancos de dados babelfish e adiciona-los a role deny_dml

DECLARE @dbName NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);
DECLARE @login NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master','model','msdb','tempdb')
      AND state_desc = 'ONLINE';

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @dbName;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE login_cursor CURSOR FOR
    SELECT name
    FROM sys.syslogins
    WHERE sysadmin = 1 AND name NOT IN ('dbauser','sa');

    OPEN login_cursor;

    FETCH NEXT FROM login_cursor INTO @login;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @sql = 'USE ' + QUOTENAME(@dbName) + ';' +
                   'IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = ''' + @login + ''') ' +
                   'BEGIN ' +
                   'CREATE USER [' + @login + '] FOR LOGIN [' + @login + '];' +
                   'ALTER ROLE deny_dml ADD MEMBER [' + @login + '];' +
                   'PRINT ''User [' + @login + '] created and added to role deny_select in database [' + @dbName + '].''; ' +
                   'END;';

        -- Exibir o comando SQL gerado
        --PRINT @sql;

        -- Executar o script
        EXEC sp_executesql @sql;

        FETCH NEXT FROM login_cursor INTO @login;
    END

    CLOSE login_cursor;
    DEALLOCATE login_cursor;

    FETCH NEXT FROM db_cursor INTO @dbName;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
