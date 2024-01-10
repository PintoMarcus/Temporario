DO $$ 
DECLARE 
    table_schema text := 'dbo';
    table_name text := 'teste';
    create_table_script text;
BEGIN
    SELECT 'CREATE TABLE ' || table_schema || '.' || table_name || E'\n(\n' || 
           string_agg(column_definition, E',\n') || E'\n);'
    INTO create_table_script
    FROM (
        SELECT 
            column_name || ' ' || data_type || 
                CASE 
                    WHEN character_maximum_length IS NOT NULL THEN '(' || character_maximum_length || ')'
                    ELSE ''
                END AS column_definition
        FROM information_schema.columns
        WHERE table_schema = table_schema
          AND table_name = table_name
        ORDER BY ordinal_position
    ) AS columns_info;

    RAISE NOTICE '%', create_table_script;
END $$;
