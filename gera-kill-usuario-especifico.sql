DECLARE @UserName NVARCHAR(255) = 'teste';
DECLARE @SPID INT;

-- Criação de uma tabela temporária para armazenar SPIDs
CREATE TABLE #UserSessions (SPID INT);

-- Inserção de SPIDs das sessões do usuário na tabela temporária
INSERT INTO #UserSessions (SPID)
SELECT session_id
FROM sys.dm_exec_sessions
WHERE login_name = @UserName;

-- Loop para matar sessões do usuário
DECLARE @RowCount INT = (SELECT COUNT(*) FROM #UserSessions);
DECLARE @Counter INT = 1;

WHILE @Counter <= @RowCount
BEGIN
    SELECT TOP 1 @SPID = SPID FROM #UserSessions;

    DECLARE @KillStatement NVARCHAR(100);
    SET @KillStatement = 'KILL ' + CAST(@SPID AS NVARCHAR(10));
    EXEC(@KillStatement);
	print @KillStatement;
    DELETE FROM #UserSessions WHERE SPID = @SPID;

    SET @Counter = @Counter + 1;
END

-- Limpeza da tabela temporária
DROP TABLE #UserSessions;
