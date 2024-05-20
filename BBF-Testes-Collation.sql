SELECT name 
FROM testtable1 
WHERE name ~ 'a';

SELECT name FROM testtable1 WHERE name LIKE '[a-z]%';

SELECT name 
FROM testtable1 
WHERE name SIMILAR TO '%a%';

SELECT name 
FROM testtable1 
WHERE STRPOS(name, 'a') > 0;

SELECT name 
FROM testtable1 
ORDER BY name;

SELECT STRING_AGG(name, ', ')
FROM testtable1;

SELECT value FROM STRING_SPLIT('a,b,c', ',');

SELECT CHARINDEX('a', name) FROM testtable1;


SELECT name 
FROM testtable1 
WHERE SOUNDEX(name) = SOUNDEX('a');

SELECT DISTINCT name FROM testtable1;

SELECT name, COUNT(*) FROM testtable1 GROUP BY name;

SELECT name FROM testtable1 WHERE name = 'example';

SELECT a.name, b.description 
FROM table1 a
JOIN table2 b ON a.name = b.name;


-- Passo 1: Criar a tabela
CREATE TABLE testtable1 (
    id serial PRIMARY KEY,
    name varchar(255) COLLATE "C"
);

-- Passo 2: Inserir dados na tabela
INSERT INTO testtable1 (name) VALUES ('apple'), ('banana'), ('cherry');

-- Passo 3: Executar a consulta utilizando PATINDEX
SELECT PATINDEX('%a%', name) FROM testtable1;


-- Passo 1: Criar a tabela
CREATE TABLE testtable1 (
    id serial PRIMARY KEY,
    name varchar(255) COLLATE "C"
);

-- Passo 2: Inserir dados na tabela
INSERT INTO testtable1 (name) VALUES ('apple'), ('banana'), ('cherry');

-- Passo 3: Executar a consulta
SELECT CHARINDEX('a', name) FROM testtable1;



---------------------------------------------------------------

-- Passo 1: Criar a tabela temporária
CREATE TABLE #tbteste (
    id INT PRIMARY KEY,
    name NVARCHAR(255)
);

-- Passo 2: Inserir dados na tabela temporária
INSERT INTO #tbteste (id, name) VALUES 
(1, 'apple'),
(2, 'banana'),
(3, 'cherry'),
(4, 'date'),
(5, 'elderberry'),
(6, 'fig'),
(7, 'grape'),
(8, 'honeydew');

-- Passo 3: Executar a consulta utilizando STRING_AGG com conversão para NVARCHAR(MAX)
SELECT STRING_AGG(CAST(name AS NVARCHAR(MAX)), ', ') AS concatenated_names
FROM #tbteste;
---------------------------------------------------------------



-------------------------------------------------------------------
-- Passo 1: Criar a tabela temporária
CREATE TABLE #tbteste (
    id INT PRIMARY KEY,
    name NVARCHAR(255)
);

-- Passo 2: Inserir dados na tabela temporária
INSERT INTO #tbteste (id, name) VALUES
(1, 'apple'),
(2, 'banana'),
(3, 'cherry'),
(4, 'date'),
(5, 'elderberry'),
(6, 'fig'),
(7, 'grape'),
(8, 'honeydew'),
(9, NULL);

-- Passo 3: Executar a consulta utilizando STRING_AGG com conversão para NVARCHAR(MAX)
SELECT STRING_AGG(CAST(name AS NVARCHAR(MAX)), ', ') AS concatenated_names
FROM #tbteste;

SELECT REPLACE(name, 'apple', 'applenew') AS nome_substituido
FROM #tbteste;

SELECT COALESCE(name, 'Default Name') AS nome_coalescido
FROM #tbteste;

SELECT CAST(name AS NVARCHAR(300)) AS nome_cast
FROM #tbteste;

SELECT CONVERT(NVARCHAR(300), name) AS nome_convertido
FROM #tbteste;


SELECT REPLACE(COALESCE(name, 'Default Name'), 'apple', 'applenew') AS nome_modificado
FROM #tbteste;

SELECT STUFF(name, 5, 0, 'new') AS nome_stuffed
FROM #tbteste;

SELECT SUBSTRING(name, 1, 2) AS nome_substring
FROM #tbteste;

SELECT 
    LEFT(name, 5) AS nome_left,
    RIGHT(name, 5) AS nome_right
FROM #tbteste;


SELECT CHARINDEX('app', name) AS posicao_old
FROM #tbteste;

drop table #tbteste;

--------------------------------------------------------










