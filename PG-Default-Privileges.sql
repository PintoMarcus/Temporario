-- Verificar as permissões padrão atuais:
-- Para verificar os privilégios padrão atuais em um schema, você pode consultar a visualização do catálogo do sistema pg_default_acl:
SELECT * 
FROM pg_default_acl 
WHERE defaclnamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'shema-name');


/*************** SCHEMA Início ****************************/
GRANT ALL ON SCHEMA shema-name TO USERNAME WITH GRANT OPTION;
/*************** SCHEMA Fim ****************************/


/*************** TABELAS Início ****************************/
-- TABLES
--Configure os privilégios padrão para que as novas tabelas herdem automaticamente essas permissões:
ALTER DEFAULT PRIVILEGES FOR ROLE database_dbo IN SCHEMA shema-name
GRANT REFERENCES, TRIGGER ON TABLES TO USERNAME WITH GRANT OPTION;

GRANT REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA database_dbo TO USERNAME WITH GRANT OPTION;

-- CASO QUEIRA GERAR O COMANDO PARA TODAS Conceda as permissões desejadas às tabelas existentes no schema shema-name:
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'shema-name'
    LOOP
        EXECUTE 'GRANT REFERENCES, TRIGGER ON TABLE shema-name.' || r.tablename || ' TO USERNAME;';
    END LOOP;
END $$;

/*************** TABELAS FIM ****************************/


/*************** SEQUENCES Início ****************************/
ALTER DEFAULT PRIVILEGES FOR ROLE database_dbo IN SCHEMA shema-name
GRANT SELECT, USAGE ON SEQUENCES TO USERNAME WITH GRANT OPTION;

GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA database_dbo TO USERNAME WITH GRANT OPTION;
/*************** SEQUENCES Fim ****************************/


/*************** FUNCTIONS Início ****************************/
ALTER DEFAULT PRIVILEGES FOR ROLE database_dbo IN SCHEMA shema-name
GRANT EXECUTE ON FUNCTIONS TO USERNAME WITH GRANT OPTION;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA database_dbo TO USERNAME WITH GRANT OPTION;
/*************** FUNCTIONS Fim ****************************/


/*************** TYPES Início ****************************/
-- TYPE
ALTER DEFAULT PRIVILEGES FOR ROLE database_dbo IN SCHEMA shema-name
GRANT USAGE ON TYPES TO USERNAME WITH GRANT OPTION;


GRANT USAGE ON TYPE schema.type_name TO user;

-- Eexemplo de script SQL que gera os comandos GRANT USAGE para todos os TYPES em um esquema chamado shema-name:
DO $$ 
DECLARE 
    rec RECORD;
BEGIN
    FOR rec IN 
        SELECT typname, nspname 
        FROM pg_type 
        JOIN pg_namespace ON pg_type.typnamespace = pg_namespace.oid 
        WHERE nspname = 'shema-name'
    LOOP
        EXECUTE 'GRANT USAGE ON TYPE ' || quote_ident(rec.nspname) || '.' || quote_ident(rec.typname) || ' TO USERNAME';
    END LOOP;
END $$;
/*************** TYPES FIM ****************************/




/******************** FUNÇÃO PARA AUTOMATIZAR ************************/
CREATE OR REPLACE FUNCTION grant_dba_permissions(
    target_schema TEXT,
    target_role TEXT,
    target_user TEXT
)
RETURNS VOID AS $$
BEGIN
    -- Grant all privileges on the schema
    EXECUTE format('GRANT ALL ON SCHEMA %I TO %I WITH GRANT OPTION;', target_schema, target_user);

    -- Alter default privileges for tables
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT REFERENCES, TRIGGER ON TABLES TO %I WITH GRANT OPTION;', target_role, target_schema, target_user);

    -- Alter default privileges for sequences
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT, USAGE ON SEQUENCES TO %I WITH GRANT OPTION;', target_role, target_schema, target_user);

    -- Alter default privileges for functions
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT EXECUTE ON FUNCTIONS TO %I WITH GRANT OPTION;', target_role, target_schema, target_user);

    -- Alter default privileges for types
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT USAGE ON TYPES TO %I WITH GRANT OPTION;', target_role, target_schema, target_user);

    -- Grant specific privileges on all current tables
    EXECUTE format('GRANT REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA %I TO %I WITH GRANT OPTION;', target_schema, target_user);

    -- Grant specific privileges on all current sequences
    EXECUTE format('GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA %I TO %I WITH GRANT OPTION;', target_schema, target_user);

    -- Grant specific privileges on all current functions
    EXECUTE format('GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA %I TO %I WITH GRANT OPTION;', target_schema, target_user);

    -- Grant usage on all types in the schema
    PERFORM
    (
        SELECT typname, nspname
        FROM pg_type
        JOIN pg_namespace ON pg_type.typnamespace = pg_namespace.oid
        WHERE nspname = target_schema
    );

    FOR rec IN 
        SELECT typname, nspname
        FROM pg_type
        JOIN pg_namespace ON pg_type.typnamespace = pg_namespace.oid
        WHERE nspname = target_schema
    LOOP
        EXECUTE format('GRANT USAGE ON TYPE %I.%I TO %I;', rec.nspname, rec.typname, target_user);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

/********************************************************************************************/
-- CHAMADA DA FUNÇÂO
SELECT grant_dba_permissions('nome-schema', 'nome-role_dbo', 'role-dba-access');
