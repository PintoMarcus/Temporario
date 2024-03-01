CREATE OR REPLACE FUNCTION grant_to_pipeline(role_name TEXT)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Concede a permissão à role pipeline apenas se o role_name não estiver na lista proibida
    IF role_name NOT IN ('sysadmin', 'pg_kill', 'pg_ddladmin') THEN
        EXECUTE 'GRANT ' || role_name || ' TO pipeline';
    END IF;
END;
$$;

-- Agora, sempre que você criar uma nova role, chame a função explicitamente
-- Substitua 'novarole' pelo nome da role que você acabou de criar
SELECT grant_to_pipeline('novarole');

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/



CREATE OR REPLACE FUNCTION grant_to_pipeline(role_name text)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER  -- Isso permite que a função seja executada com os privilégios do proprietário (pipeline)
AS $$
BEGIN
    -- Concede a permissão à role pipeline
    EXECUTE 'GRANT ' || role_name || ' TO pipeline';
END;
$$;

-- Agora, sempre que você criar uma nova role, chame a função explicitamente
-- Substitua 'novarole' pelo nome da role que você acabou de criar
SELECT grant_to_pipeline('novarole');

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
--- para executra através do babelfish
-- Substitua 'novarole' pelo nome real da role que você deseja conceder à role pipeline
DECLARE @role_name NVARCHAR(255) = 'novarole';
DECLARE @sql NVARCHAR(MAX);

-- Construa o comando SQL dinâmico
SET @sql = 'SELECT grant_to_pipeline(' + QUOTENAME(@role_name, '''') + ')';

-- Execute o comando usando sp_executesql
EXEC sp_executesql @sql;

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-- função para grant nas roles _dbo para o usuário pipeline
CREATE OR REPLACE FUNCTION grant_to_pipeline()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
DECLARE
    role_name text;
BEGIN
    SELECT current_user INTO role_name;

    -- Verifica se o nome da role atende aos critérios
    IF role_name ~ '_dbo$' THEN
        -- Concede a permissão à role pipeline
        EXECUTE 'GRANT ' || role_name || ' TO pipeline';
    END IF;
END;
$$;



-- trigger que dispara a função.
CREATE EVENT TRIGGER grant_to_pipeline_trigger
ON ddl_command_end
WHEN TAG IN ('CREATE ROLE')
EXECUTE FUNCTION grant_to_pipeline();



/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-- função semelhante a anterior , mas que irá dar o grant se para qualquer role criada desde que exista com schema com mesmo nome
CREATE OR REPLACE FUNCTION grant_to_pipeline()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
DECLARE
    role_name text;
    schema_exists boolean;
BEGIN
    SELECT current_user INTO role_name;

    -- Verifica se o schema com o mesmo nome da role existe
    EXECUTE 'SELECT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = $1)' INTO schema_exists
    USING role_name;

    -- Se o schema existe, concede a permissão à role pipeline
    IF schema_exists THEN
        EXECUTE 'GRANT ' || role_name || ' TO pipeline';
    END IF;
END;
$$;




/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-- função semelhante a anterior , mas que irá dar o grant se para qualquer role criada desde que seja criado um schema com mesmo nome
CREATE OR REPLACE FUNCTION grant_to_pipeline()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
DECLARE
    role_name text;
BEGIN
    SELECT current_user INTO role_name;

    -- Verifica se o schema com o mesmo nome da role existe
    IF EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = role_name) THEN
        -- Se o schema existe, concede a permissão à role pipeline
        EXECUTE 'GRANT ' || role_name || ' TO pipeline';
    END IF;
END;
$$;

CREATE EVENT TRIGGER grant_pipeline_trigger
ON ddl_command_end
WHEN TAG IN ('CREATE ROLE')
EXECUTE FUNCTION grant_to_pipeline();



