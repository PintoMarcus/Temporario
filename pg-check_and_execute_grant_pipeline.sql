-- Primeiro, você precisa identificar todas as roles que começam com "db" e que o usuário "pipeline" não possui permissão.
-- Em seguida, você executa a função grant_pipelinerdsuser para cada uma dessas roles retornadas pela consulta anterior.

CREATE OR REPLACE FUNCTION check_and_execute_grant_pipeline()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    role_name TEXT;
BEGIN
    -- Cria uma tabela temporária para armazenar as roles que o usuário "pipeline" não possui permissão
    CREATE TEMP TABLE IF NOT EXISTS roles_to_check (role_name TEXT);

    -- Limpa a tabela temporária para evitar duplicatas
    DELETE FROM roles_to_check;

    -- Insere as roles que começam com "db" e que o usuário "pipeline" não possui permissão na tabela temporária
    INSERT INTO roles_to_check
    SELECT rolname
    FROM pg_roles
    WHERE rolname LIKE 'db%' AND NOT EXISTS (
        SELECT 1
        FROM pg_auth_members
        WHERE roleid = (SELECT oid FROM pg_roles WHERE rolname = 'pipelinerdsuser')
        AND member = pg_roles.oid
    );

    -- Para cada role na tabela temporária, execute a função grant_pipelinerdsuser
    FOR role_name IN SELECT role_name FROM roles_to_check LOOP
        PERFORM grant_pipelinerdsuser(role_name);
    END LOOP;
END;
$$;


------
Executar a chamada da função:
SELECT check_and_execute_grant_pipeline();


--- Criando agendamento

CREATE EXTENSION pg_cron;

SELECT cron.schedule('*/5 * * * *', 'SELECT check_and_execute_grant_pipeline()');

