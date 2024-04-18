CREATE OR REPLACE FUNCTION OCDN(p_sql_statement text)
RETURNS VOID AS $$
BEGIN
    -- Adiciona a expressão ON CONFLICT DO NOTHING ao final da instrução INSERT
    EXECUTE p_sql_statement || ' ON CONFLICT DO NOTHING;';
END;
$$ LANGUAGE plpgsql;


-- EXEMPLO:
SELECT OCDN('
    INSERT INTO dbo.tb_sv9_01 (cd_codigo_cota, dt_data_cota, dt_data_alteracao, ds_comentario, ds_user)
    VALUES 
        (''valor1'', ''2024-04-12'', ''2024-04-12 10:00:00'', ''Comentário 1'', ''User 1''),
        (''valor2'', ''2024-04-12'', ''2024-04-12 10:00:00'', ''Comentário 2'', ''User 2'')
');
