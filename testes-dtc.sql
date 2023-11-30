-- TESTES DTC

--Verificar Configurações do DTC: O resultado deve ser 1, o que significa que consultas distribuídas ad hoc são permitidas.
EXEC sp_configure 'Ad Hoc Distributed Queries';


-- Verificar Se o DTC Está Ativo: (Se houver transações ativas, o DTC está em execução.)

SELECT * FROM sys.dm_tran_active_transactions;


-- Teste de Transações Distribuídas: (Teste Básico com COMMIT)
BEGIN DISTRIBUTED TRANSACTION;
-- Seu código de transação aqui
COMMIT;

-- Teste de Transações Distribuídas: (Teste Básico com ROLLBACK)
BEGIN DISTRIBUTED TRANSACTION;
-- Seu código de transação aqui
ROLLBACK;


-- Verificar Transações Distribuídas Ativas: ()
SELECT * FROM sys.dm_tran_active_transactions WHERE is_local = 0;



--- testando com openquery 001
BEGIN TRANSACTION;

-- Substitua 'RemoteServer' pelo nome do servidor remoto
-- Substitua 'DatabaseName' pelo nome do banco de dados remoto
DECLARE @Sql NVARCHAR(MAX);
SET @Sql = N'SELECT * FROM DatabaseName.SchemaName.TableName';

-- Executa a transação distribuída usando OPENQUERY
EXEC ('SELECT * FROM OPENQUERY(RemoteServer, ''' + @Sql + ''')');

-- Commit ou Rollback da transação distribuída
COMMIT; -- ou ROLLBACK;


-- testando com openquery 002
-- Criação da tabela temporária global
CREATE TABLE ##TempTable (
    -- Defina as colunas conforme a estrutura da tabela remota
    Col1 INT,
    Col2 VARCHAR(50),
    -- Adicione outras colunas conforme necessário
);
-- Inicia uma transação distribuída
BEGIN DISTRIBUTED TRANSACTION;

-- Substitua 'SRV_002.meudomini.abc' pelo nome do servidor remoto completo
-- Substitua 'sch1' pelo esquema no servidor remoto
-- Substitua 'mtb1' pela tabela no servidor remoto
DECLARE @Sql NVARCHAR(MAX);
SET @Sql = N'select top 10 * from [sch1].[mtb1]';

-- Executa a transação distribuída usando OPENQUERY
-- Cria uma tabela temporária no servidor local para armazenar os resultados
EXEC ('SELECT * INTO ##TempTable FROM OPENQUERY([SRV_002.meudomini.abc], ''' + @Sql + ''') AT [SRV_002.meudomini.abc]');

-- Espera por 15 segundos
WAITFOR DELAY '00:00:15';

-- Seleciona os resultados da tabela temporária
SELECT * FROM ##TempTable;

-- Commit ou Rollback da transação distribuída
COMMIT; -- ou ROLLBACK;

-- Limpa a tabela temporária após o uso
DROP TABLE ##TempTable;



----
USE AdventureWorks2022;
GO
BEGIN DISTRIBUTED TRANSACTION;
-- Delete candidate from local instance.
DELETE AdventureWorks2022.HumanResources.JobCandidate
    WHERE JobCandidateID = 13;
-- Delete candidate from remote instance.
DELETE RemoteServer.AdventureWorks2022.HumanResources.JobCandidate
    WHERE JobCandidateID = 13;
COMMIT TRANSACTION;
GO
