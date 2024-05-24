--Dependências da Procedure (Objetos dos quais a Procedure Depende)
SELECT 
    referenced_entity_name,
    o.type_desc AS referenced_object_type
FROM 
    sys.sql_expression_dependencies d
JOIN 
    sys.objects o ON d.referenced_id = o.object_id
WHERE 
    d.referencing_id = OBJECT_ID('dbo.pr_teste');


--Dependências da Procedure (Objetos que Dependem da Procedure)
SELECT 
    referencing_entity_name,
    o.type_desc AS referencing_object_type
FROM 
    sys.sql_expression_dependencies d
JOIN 
    sys.objects o ON d.referencing_id = o.object_id
WHERE 
    d.referenced_id = OBJECT_ID('dbo.pr_teste');

--Procedura Armazenada sp_depends
EXEC sp_depends 'dbo.pr_teste';


--Dependências da Procedure (Objetos dos quais a Procedure Depende)
SELECT 
    referenced_entity_name, 
    referenced_minor_name, 
    referenced_class_desc, 
    referenced_minor_id 
FROM 
    sys.dm_sql_referenced_entities ('dbo.pr_teste', 'OBJECT');


--Dependências da Procedure (Objetos que Dependem da Procedure)
SELECT 
    referencing_schema_name, 
    referencing_entity_name, 
    referencing_id, 
    referencing_class_desc, 
    is_caller_dependent 
FROM 
    sys.dm_sql_referencing_entities ('dbo.pr_teste', 'OBJECT');


--Para encontrar os objetos dos quais a stored procedure pr_teste depende:
SELECT 
    referenced_entity_name,
    o.type_desc AS referenced_object_type
FROM 
    sys.sql_expression_dependencies d
JOIN 
    sys.objects o ON d.referenced_id = o.object_id
WHERE 
    d.referencing_id = OBJECT_ID('dbo.pr_teste');


--Para encontrar os objetos que dependem da stored procedure pr_teste:
SELECT 
    referencing_entity_name,
    o.type_desc AS referencing_object_type
FROM 
    sys.sql_expression_dependencies d
JOIN 
    sys.objects o ON d.referencing_id = o.object_id
WHERE 
    d.referenced_id = OBJECT_ID('dbo.pr_teste');



