-- scrips com objetivo de verificar comportamento de ordenação de collation no babelfish.
-- crio duas tabelas, populo com valores pré determinados, realizo consultas para verificar ordenação.

-- Criação da tabela TBTESTE1
CREATE TABLE TBTESTE1 (
    col1tb1 BIGINT PRIMARY KEY,
    col2tb1 NVARCHAR(255),
    col3tb1 NVARCHAR(255),
    col4tb1 NVARCHAR(255),
    col5tb1 NVARCHAR(255),
    col6tb1 NVARCHAR(255),
    col7tb1 NVARCHAR(255),
    col8tb1 NVARCHAR(255),
    col9tb1 NVARCHAR(255),
    col10tb1 NVARCHAR(255)
);

-- Criação da tabela TBTESTE2
CREATE TABLE TBTESTE2 (
    col1tb2 BIGINT PRIMARY KEY,
    col2tb2 NVARCHAR(255),
    col3tb2 NVARCHAR(255),
    col4tb2 NVARCHAR(255),
    col5tb2 NVARCHAR(255),
    col6tb2 NVARCHAR(255),
    col7tb2 NVARCHAR(255),
    col8tb2 NVARCHAR(255),
    col9tb2 NVARCHAR(255),
    col10tb2 NVARCHAR(255)
);


-----População das tabelas com 1 milhão de registros cada
-- Populando a tabela TBTESTE1
SET NOCOUNT ON;
DECLARE @i BIGINT = 1;

WHILE @i <= 1000000
BEGIN
     INSERT INTO TBTESTE1 (col1tb1, col2tb1, col3tb1, col4tb1, col5tb1, col6tb1, col7tb1, col8tb1, col9tb1, col10tb1)
    VALUES (@i, 'Valuec' + CAST(@i AS NVARCHAR(255)), 'Valuec' + CAST(@i + 1 AS NVARCHAR(255)), 'Váluec' + CAST(@i + 2 AS NVARCHAR(255)), 
            'Valúec' + CAST(@i + 3 AS NVARCHAR(255)), 'Valuéc' + CAST(@i + 4 AS NVARCHAR(255)), 'VÀluec' + CAST(@i + 5 AS NVARCHAR(255)), 
            'Valuêc' + CAST(@i + 6 AS NVARCHAR(255)), 'ValuÊc' + CAST(@i + 7 AS NVARCHAR(255)), 'ValÜec' + CAST(@i + 8 AS NVARCHAR(255)));
    SET @i = @i + 1;
	     INSERT INTO TBTESTE1 (col1tb1, col2tb1, col3tb1, col4tb1, col5tb1, col6tb1, col7tb1, col8tb1, col9tb1, col10tb1)
    VALUES (@i, 'Valuec', 'Valuec', 'Váluec', 
            'Valúec', 'Valuéc', 'VÀluec', 
            'Valuêc', 'ValuÊc', 'ValÜec');
    SET @i = @i + 1;
	    INSERT INTO TBTESTE1 (col1tb1, col2tb1, col3tb1, col4tb1, col5tb1, col6tb1, col7tb1, col8tb1, col9tb1, col10tb1)
    VALUES (@i, 'Valueç', 'valueç', 'válueç', 
            'valúeç', 'valuéç', 'vÀlueç', 
            'valuêç', 'valuÊç', 'valÜeç');
    SET @i = @i + 1;
	    INSERT INTO TBTESTE1 (col1tb1, col2tb1, col3tb1, col4tb1, col5tb1, col6tb1, col7tb1, col8tb1, col9tb1, col10tb1)
    VALUES (@i, 'Valuec', 'valuec', 'váluec', 
            'valúec', 'valuéc', 'vÀluec', 
            'valuêc', 'valuÊc', 'valÜec');
    SET @i = @i + 1;
		    INSERT INTO TBTESTE1 (col1tb1, col2tb1, col3tb1, col4tb1, col5tb1, col6tb1, col7tb1, col8tb1, col9tb1, col10tb1)
    VALUES (@i, 'valuec', 'vaLuec', 'váLuec', 
            'vaLúec', 'vaLué', 'vÀLuec', 
            'vaLuêc', 'vaLuÊc', 'vaLÜec');
    SET @i = @i + 1;
			    INSERT INTO TBTESTE1 (col1tb1, col2tb1, col3tb1, col4tb1, col5tb1, col6tb1, col7tb1, col8tb1, col9tb1, col10tb1)
    VALUES (@i, 'valuec', 'vaLuec', 'váLuec', 
            'vaLúec', 'vaLuéc', 'vÀLuec', 
            'vaLuêc', 'vaLuÊc', 'vaLÜec');
    SET @i = @i + 1;
			    INSERT INTO TBTESTE1 (col1tb1, col2tb1, col3tb1, col4tb1, col5tb1, col6tb1, col7tb1, col8tb1, col9tb1, col10tb1)
    VALUES (@i, 'valueç', 'vaLueç', 'váLueç', 
            'vaLúeç', 'vaLuéç', 'vÀLueç', 
            'vaLuêç', 'vaLuÊç', 'vaLÜeç');
    SET @i = @i + 1;
				    INSERT INTO TBTESTE1 (col1tb1, col2tb1, col3tb1, col4tb1, col5tb1, col6tb1, col7tb1, col8tb1, col9tb1, col10tb1)
    VALUES (@i, 'Valueç', 'VaLueç', 'VáLueç', 
            'VaLúeç', 'VaLuéç', 'VÀLueç', 
            'VaLuêç', 'VaLuÊç', 'VaLÜeç');
    SET @i = @i + 1;
END

-- Populando a tabela TBTESTE2
SET @i = 1;
WHILE @i <= 1000000
BEGIN
     INSERT INTO TBTESTE2 (col1tb2, col2tb2, col3tb2, col4tb2, col5tb2, col6tb2, col7tb2, col8tb2, col9tb2, col10tb2)
    VALUES (@i, 'Valuec' + CAST(@i AS NVARCHAR(255)), 'Valuec' + CAST(@i + 1 AS NVARCHAR(255)), 'Váluec' + CAST(@i + 2 AS NVARCHAR(255)), 
            'Valúec' + CAST(@i + 3 AS NVARCHAR(255)), 'Valuéc' + CAST(@i + 4 AS NVARCHAR(255)), 'VÀluec' + CAST(@i + 5 AS NVARCHAR(255)), 
            'Valuêc' + CAST(@i + 6 AS NVARCHAR(255)), 'ValuÊc' + CAST(@i + 7 AS NVARCHAR(255)), 'ValÜec' + CAST(@i + 8 AS NVARCHAR(255)));
    SET @i = @i + 1;
	     INSERT INTO TBTESTE2 (col1tb2, col2tb2, col3tb2, col4tb2, col5tb2, col6tb2, col7tb2, col8tb2, col9tb2, col10tb2)
    VALUES (@i, 'Valuec', 'Valuec', 'Váluec', 
            'Valúec', 'Valuéc', 'VÀluec', 
            'Valuêc', 'ValuÊc', 'ValÜec');
    SET @i = @i + 1;
	    INSERT INTO TBTESTE2 (col1tb2, col2tb2, col3tb2, col4tb2, col5tb2, col6tb2, col7tb2, col8tb2, col9tb2, col10tb2)
    VALUES (@i, 'Valueç', 'valueç', 'válueç', 
            'valúeç', 'valuéç', 'vÀlueç', 
            'valuêç', 'valuÊç', 'valÜeç');
    SET @i = @i + 1;
	    INSERT INTO TBTESTE2 (col1tb2, col2tb2, col3tb2, col4tb2, col5tb2, col6tb2, col7tb2, col8tb2, col9tb2, col10tb2)
    VALUES (@i, 'Valuec', 'valuec', 'váluec', 
            'valúec', 'valuéc', 'vÀluec', 
            'valuêc', 'valuÊc', 'valÜec');
    SET @i = @i + 1;
		    INSERT INTO TBTESTE2 (col1tb2, col2tb2, col3tb2, col4tb2, col5tb2, col6tb2, col7tb2, col8tb2, col9tb2, col10tb2)
    VALUES (@i, 'valuec', 'vaLuec', 'váLuec', 
            'vaLúec', 'vaLué', 'vÀLuec', 
            'vaLuêc', 'vaLuÊc', 'vaLÜec');
    SET @i = @i + 1;
			    INSERT INTO TBTESTE2 (col1tb2, col2tb2, col3tb2, col4tb2, col5tb2, col6tb2, col7tb2, col8tb2, col9tb2, col10tb2)
    VALUES (@i, 'valuec', 'vaLuec', 'váLuec', 
            'vaLúec', 'vaLuéc', 'vÀLuec', 
            'vaLuêc', 'vaLuÊc', 'vaLÜec');
    SET @i = @i + 1;
			    INSERT INTO TBTESTE2 (col1tb2, col2tb2, col3tb2, col4tb2, col5tb2, col6tb2, col7tb2, col8tb2, col9tb2, col10tb2)
    VALUES (@i, 'valueç', 'vaLueç', 'váLueç', 
            'vaLúeç', 'vaLuéç', 'vÀLueç', 
            'vaLuêç', 'vaLuÊç', 'vaLÜeç');
    SET @i = @i + 1;
				    INSERT INTO TBTESTE2 (col1tb2, col2tb2, col3tb2, col4tb2, col5tb2, col6tb2, col7tb2, col8tb2, col9tb2, col10tb2)
    VALUES (@i, 'Valueç', 'VaLueç', 'VáLueç', 
            'VaLúeç', 'VaLuéç', 'VÀLueç', 
            'VaLuêç', 'VaLuÊç', 'VaLÜeç');
    SET @i = @i + 1;
END



-----Consultas para testar ordenação e agrupamento
-- Ordenação por col2tb1
SELECT * FROM TBTESTE1 ORDER BY col2tb1;

-- Ordenação por col3tb2 descendente
SELECT * FROM TBTESTE2 ORDER BY col3tb2 DESC;

-- Ordenação por múltiplas colunas
SELECT * FROM TBTESTE1 ORDER BY col4tb1, col5tb1;



------Consultas com GROUP BY
-- Agrupamento e contagem por col2tb1
SELECT col2tb1, COUNT(*) AS count_group FROM TBTESTE1 GROUP BY col2tb1;

-- Agrupamento e soma por col3tb2
SELECT col3tb2, SUM(col1tb2) AS sum_group FROM TBTESTE2 GROUP BY col3tb2;

-- Agrupamento e soma por col3tb2 e ordenação
SELECT col3tb2, SUM(col1tb2) AS sum_group FROM TBTESTE2 GROUP BY col3tb2 order by sum_group;




-------Consultas com JOIN
-- Inner join entre TBTESTE1 e TBTESTE2
SELECT t1.col1tb1, t2.col1tb2, t1.col2tb1, t2.col2tb2
FROM TBTESTE1 t1
INNER JOIN TBTESTE2 t2 ON t1.col1tb1 = t2.col1tb2;

-- Left join com ordenação
SELECT t1.col1tb1, t2.col1tb2, t1.col2tb1, t2.col2tb2
FROM TBTESTE1 t1
LEFT JOIN TBTESTE2 t2 ON t1.col1tb1 = t2.col1tb2
ORDER BY t1.col2tb1;

-- Left join com ordenação e like
SELECT t1.col1tb1, t2.col1tb2, t1.col2tb1, t2.col2tb2
FROM TBTESTE1 t1
LEFT JOIN TBTESTE2 t2 ON t1.col1tb1 = t2.col1tb2
where t2.col2tb2 like '%ç%'
ORDER BY t1.col2tb1;


-- Right join com agrupamento
SELECT t1.col2tb1, t2.col3tb2, COUNT(*) AS count_group
FROM TBTESTE1 t1
RIGHT JOIN TBTESTE2 t2 ON t1.col1tb1 = t2.col1tb2
GROUP BY t1.col2tb1, t2.col3tb2;

-- Right join com agrupamento com like
SELECT t1.col2tb1, t2.col3tb2, COUNT(*) AS count_group
FROM TBTESTE1 t1
RIGHT JOIN TBTESTE2 t2 ON t1.col1tb1 = t2.col1tb2
where t1.col2tb1 like '%ç%'
GROUP BY t1.col2tb1, t2.col3tb2;  


------Consultas com funções de agregação
-- Máximo valor de col1tb1
SELECT MAX(col1tb1) AS max_value FROM TBTESTE1;

-- Mínimo valor de col3tb2
SELECT MIN(col3tb2) AS min_value FROM TBTESTE2;

-- Média de col1tb1
SELECT AVG(col1tb1) AS avg_value FROM TBTESTE1;

-- Contagem de registros
SELECT COUNT(*) AS total_count FROM TBTESTE1;



-----Consulta combinada usando funções de agregação, GROUP BY e ORDER BY
-- Consulta complexa com agregação, agrupamento e ordenação
SELECT t1.col2tb1, t2.col3tb2, COUNT(*) AS count_group, SUM(t1.col1tb1) AS sum_group
FROM TBTESTE1 t1
INNER JOIN TBTESTE2 t2 ON t1.col1tb1 = t2.col1tb2
GROUP BY t1.col2tb1, t2.col3tb2
ORDER BY count_group DESC, sum_group;




-----Consultas com HAVING
-- Agrupamento com cláusula HAVING
SELECT col2tb1, COUNT(*) AS count_group
FROM TBTESTE1
GROUP BY col2tb1
HAVING COUNT(*) > 10;

-- Agrupamento com SUM e cláusula HAVING
SELECT col3tb2, SUM(col1tb2) AS sum_group
FROM TBTESTE2
GROUP BY col3tb2
HAVING SUM(col1tb2) > 1000;


