SELECT 'VACUUM (FULL) ' || schemaname || '.' || tablename || ';' as vacuum_command
FROM pg_tables
WHERE schemaname = 'meuschema';
