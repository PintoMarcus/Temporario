SELECT rolname
FROM pg_roles r
WHERE rolname <> 'master-user'
AND rolname LIKE 'db%' 
AND rolname NOT LIKE '%_guest'
AND rolname NOT LIKE '%_owner'        
AND NOT EXISTS (
    SELECT 1
    FROM pg_auth_members am
    JOIN pg_roles pr ON am.member = pr.oid
    WHERE pr.rolname = 'pipelineuser'
    AND am.roleid = r.oid
);





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
    WHERE rolname <> 'master-user'
    AND rolname LIKE 'db%' 
    AND rolname NOT LIKE '%_guest'
    AND rolname NOT LIKE '%_owner'        
    AND NOT EXISTS (
        SELECT 1
        FROM pg_auth_members
        WHERE roleid = (SELECT oid FROM pg_roles WHERE rolname = 'pipelineuser')
        AND member = pg_roles.oid
    );

    -- Para cada role na tabela temporária, execute o comando GRANT
    FOR role_name IN SELECT role_name FROM roles_to_check LOOP
        EXECUTE 'GRANT ' || quote_ident(role_name) || ' TO pipelineuser';
    END LOOP;
END;
$$;




-- Primeiro, você precisa identificar todas as roles que começam com "db" e que o usuário "pipeline" não possui permissão.
-- Em seguida, você executa a função grant_pipelinesuser para cada uma dessas roles retornadas pela consulta anterior.

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
        WHERE roleid = (SELECT oid FROM pg_roles WHERE rolname = 'pipelineuser')
        AND member = pg_roles.oid
    );

    -- Para cada role na tabela temporária, execute a função grant_pipelineuser
    FOR role_name IN SELECT role_name FROM roles_to_check LOOP
        PERFORM grant_pipelineuser(role_name);
    END LOOP;
END;
$$;


------
Executar a chamada da função:
SELECT check_and_execute_grant_pipeline();


--- Criando agendamento

CREATE EXTENSION pg_cron;

SELECT cron.schedule('*/5 * * * *', 'SELECT check_and_execute_grant_pipeline()');

