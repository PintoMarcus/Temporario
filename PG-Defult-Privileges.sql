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
