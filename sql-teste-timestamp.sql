++++++++++++++++++++++++++++++++++++++++++++++++
  -- Script para inserir 100 valores aleatórios com commits individuais
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    INSERT INTO erros (C0)
    VALUES ('Valor_' + CAST(@i AS NVARCHAR(MAX)));
    
    SET @i = @i + 1;
END;

-- Script para inserir 100 valores aleatórios com um único commit
BEGIN TRANSACTION;
DECLARE @j INT = 101;
WHILE @j <= 200
BEGIN
    INSERT INTO erros (C0)
    VALUES ('Valor_' + CAST(@j AS NVARCHAR(MAX)));
    SET @j = @j + 1;
END;
COMMIT;


++++++++++++++++++++++++++++++++++++++++++++++++
BULK INSERT erros
FROM 'C:\temp\bulk.txt'  
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\r',    
    FIRSTROW = 1            
);




SELECT 
    C0,
    CONVERT(DATETIME, [TIME]) AS [TIME]
FROM 
    erros;


SELECT 
    C0,
    TO_CHAR(TIME::timestamp, 'YYYY-MM-DD HH24:MI:SS') AS TIME
FROM 
    erros;


SELECT 
    C0,
    TO_CHAR(TO_TIMESTAMP(TIME, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') AS TIME
FROM 
    erros;
