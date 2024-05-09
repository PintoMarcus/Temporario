-- Para uso no Babelfish
-- Script cria logins a partir da lista inserida na tabela temporária #Usuarios e atribui uma senha aleatória para eles.
-- Senhas serão alteradas via postgres usando o hash dos usuários.

-- Criar tabela temporária para armazenar os usuários e senhas
CREATE TABLE #Usuarios (
    Usuario NVARCHAR(100)
);

-- Inserir os usuários na tabela temporária
INSERT INTO #Usuarios (Usuario) VALUES
('usuario1'),
('usuario2'),
('usuario3');

-- Declarar variáveis
DECLARE @Usuario NVARCHAR(100);
DECLARE @Senha NVARCHAR(50);

-- Iniciar o cursor para percorrer os usuários
DECLARE UsuariosCursor CURSOR FOR
SELECT Usuario FROM #Usuarios;

-- Abrir o cursor
OPEN UsuariosCursor;

-- Iniciar a variável @Usuario
FETCH NEXT FROM UsuariosCursor INTO @Usuario;

-- Loop através dos usuários
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Gerar senha aleatória
    SET @Senha = CONVERT(NVARCHAR(50), NEWID());

    -- Exibir a senha gerada
    PRINT 'Senha Aleatória Gerada para ' + @Usuario + ': ' + @Senha;

    -- Criar o comando SQL para criar o login
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'CREATE LOGIN ' + QUOTENAME(@Usuario) + ' WITH PASSWORD = ' + QUOTENAME(@Senha, '''');
    -- Executar o comando SQL para criar o login
    EXEC sp_executesql @SQL;

    -- Criar o comando SQL para conceder sysadmin ao login
    DECLARE @SQL2 NVARCHAR(MAX);
    SET @SQL2 = 'ALTER SERVER ROLE sysadmin ADD MEMBER ' + QUOTENAME(@Usuario) ;
    -- Executar o comando SQL para criar o login
    EXEC sp_executesql @SQL2;

    -- Obter o próximo usuário
    FETCH NEXT FROM UsuariosCursor INTO @Usuario;
END

-- Fechar o cursor
CLOSE UsuariosCursor;
DEALLOCATE UsuariosCursor;

-- Limpar a tabela temporária
DROP TABLE #Usuarios;
