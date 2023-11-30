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
