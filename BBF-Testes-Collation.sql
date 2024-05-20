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











