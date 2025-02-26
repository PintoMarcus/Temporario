-- Script para teste de stress

-- Criação de tabelas
CREATE TABLE Table1 (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50),
    DateCreated DATETIME,
    Value DECIMAL(18, 2)
);

CREATE TABLE Table2 (
    ID INT PRIMARY KEY,
    Description NVARCHAR(255),
    Quantity INT,
    Price DECIMAL(18, 2)
);

CREATE TABLE Table3 (
    ID INT PRIMARY KEY,
    Category NVARCHAR(50),
    IsActive BIT,
    CreatedBy NVARCHAR(50)
);

CREATE TABLE Table4 (
    ID INT PRIMARY KEY,
    Username NVARCHAR(50),
    PasswordHash NVARCHAR(255),
    LastLogin DATETIME
);

CREATE TABLE Table5 (
    ID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(18, 2)
);

CREATE TABLE Table6 (
    ID INT PRIMARY KEY,
    Address NVARCHAR(255),
    City NVARCHAR(50),
    State NVARCHAR(50),
    ZipCode NVARCHAR(10)
);

CREATE TABLE Table7 (
    ID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(18, 2)
);

CREATE TABLE Table8 (
    ID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    CategoryID INT,
    StockQuantity INT
);

CREATE TABLE Table9 (
    ID INT PRIMARY KEY,
    EmployeeID INT,
    DepartmentID INT,
    HireDate DATETIME
);

CREATE TABLE Table10 (
    ID INT PRIMARY KEY,
    TransactionID INT,
    Amount DECIMAL(18, 2),
    TransactionDate DATETIME
);



--002
-- Inserir dados nas tabelas
DECLARE @i INT = 1;
WHILE @i <= 100000
BEGIN
    INSERT INTO Table1 (ID, Name, DateCreated, Value) VALUES (@i, CONCAT('Name', @i), GETDATE(), RAND() * 1000);
    INSERT INTO Table2 (ID, Description, Quantity, Price) VALUES (@i, CONCAT('Description', @i), FLOOR(RAND() * 100), RAND() * 100);
    INSERT INTO Table3 (ID, Category, IsActive, CreatedBy) VALUES (@i, CONCAT('Category', @i), RAND() * 2, CONCAT('User', @i));
    INSERT INTO Table4 (ID, Username, PasswordHash, LastLogin) VALUES (@i, CONCAT('User', @i), HASHBYTES('SHA2_256', CONCAT('Password', @i)), GETDATE());
    INSERT INTO Table5 (ID, OrderID, ProductID, Quantity, Price) VALUES (@i, FLOOR(RAND() * 1000), FLOOR(RAND() * 1000), FLOOR(RAND() * 10), RAND() * 100);
    INSERT INTO Table6 (ID, Address, City, State, ZipCode) VALUES (@i, CONCAT('Address', @i), CONCAT('City', @i), CONCAT('State', @i), CONCAT('Zip', @i));
    INSERT INTO Table7 (ID, CustomerID, OrderDate, TotalAmount) VALUES (@i, FLOOR(RAND() * 1000), GETDATE(), RAND() * 1000);
    INSERT INTO Table8 (ID, ProductName, CategoryID, StockQuantity) VALUES (@i, CONCAT('Product', @i), FLOOR(RAND() * 100), FLOOR(RAND() * 100));
    INSERT INTO Table9 (ID, EmployeeID, DepartmentID, HireDate) VALUES (@i, FLOOR(RAND() * 1000), FLOOR(RAND() * 100), GETDATE());
    INSERT INTO Table10 (ID, TransactionID, Amount, TransactionDate) VALUES (@i, FLOOR(RAND() * 1000), RAND() * 1000, GETDATE());

    SET @i = @i + 1;
END;


--003
-- Teste de I/O: Leituras intensivas
SELECT * FROM Table1 ORDER BY DateCreated;
SELECT * FROM Table5 WHERE OrderID BETWEEN 1 AND 50000 ORDER BY Price;


--004
-- Teste de CPU: Cálculos intensivos
SELECT SUM(Value) FROM Table1;
SELECT AVG(Price) FROM Table2;

--005
-- Teste de Memória: Grandes junções
SELECT 
    t1.ID, t1.Name, t2.Description, t3.Category 
FROM 
    Table1 t1
JOIN 
    Table2 t2 ON t1.ID = t2.ID
JOIN 
    Table3 t3 ON t1.ID = t3.ID;


--006
-- Teste com Tabelas Temporárias
CREATE TABLE #TempTable (ID INT, Value DECIMAL(18, 2));
INSERT INTO #TempTable (ID, Value) SELECT ID, Value FROM Table1;
SELECT * FROM #TempTable WHERE Value > 500;
DROP TABLE #TempTable;


----TESTES ADICIONAIS
---007 
-- Inserções em massa (Escrita intensiva)
DECLARE @i INT = 100001;
WHILE @i <= 200000
BEGIN
    INSERT INTO Table1 (ID, Name, DateCreated, Value) VALUES (@i, CONCAT('Name', @i), GETDATE(), RAND() * 1000);
    INSERT INTO Table2 (ID, Description, Quantity, Price) VALUES (@i, CONCAT('Description', @i), FLOOR(RAND() * 100), RAND() * 100);
    INSERT INTO Table3 (ID, Category, IsActive, CreatedBy) VALUES (@i, CONCAT('Category', @i), RAND() * 2, CONCAT('User', @i));
    INSERT INTO Table4 (ID, Username, PasswordHash, LastLogin) VALUES (@i, CONCAT('User', @i), HASHBYTES('SHA2_256', CONCAT('Password', @i)), GETDATE());
    INSERT INTO Table5 (ID, OrderID, ProductID, Quantity, Price) VALUES (@i, FLOOR(RAND() * 1000), FLOOR(RAND() * 1000), FLOOR(RAND() * 10), RAND() * 100);
    INSERT INTO Table6 (ID, Address, City, State, ZipCode) VALUES (@i, CONCAT('Address', @i), CONCAT('City', @i), CONCAT('State', @i), CONCAT('Zip', @i));
    INSERT INTO Table7 (ID, CustomerID, OrderDate, TotalAmount) VALUES (@i, FLOOR(RAND() * 1000), GETDATE(), RAND() * 1000);
    INSERT INTO Table8 (ID, ProductName, CategoryID, StockQuantity) VALUES (@i, CONCAT('Product', @i), FLOOR(RAND() * 100), FLOOR(RAND() * 100));
    INSERT INTO Table9 (ID, EmployeeID, DepartmentID, HireDate) VALUES (@i, FLOOR(RAND() * 1000), FLOOR(RAND() * 100), GETDATE());
    INSERT INTO Table10 (ID, TransactionID, Amount, TransactionDate) VALUES (@i, FLOOR(RAND() * 1000), RAND() * 1000, GETDATE());
    
    SET @i = @i + 1;
END;


--- 008 
-- Atualizações em massa (Escrita intensiva)
DECLARE @i INT = 1;
WHILE @i <= 100000
BEGIN
    UPDATE Table1 SET Value = Value * 1.1 WHERE ID = @i;
    UPDATE Table2 SET Price = Price * 1.1 WHERE ID = @i;
    UPDATE Table3 SET IsActive = 1 - IsActive WHERE ID = @i;
    UPDATE Table4 SET LastLogin = GETDATE() WHERE ID = @i;
    UPDATE Table5 SET Quantity = Quantity + 1 WHERE ID = @i;
    
    SET @i = @i + 1;
END;


-- 009 
-- Exclusões em massa (Escrita intensiva)
DECLARE @i INT = 1;
WHILE @i <= 10000
BEGIN
    DELETE FROM Table1 WHERE ID = @i;
    DELETE FROM Table2 WHERE ID = @i;
    DELETE FROM Table3 WHERE ID = @i;
    DELETE FROM Table4 WHERE ID = @i;
    DELETE FROM Table5 WHERE ID = @i;
    
    SET @i = @i + 1;
END;


--- Índices
-- 010
-- Criação de índices
CREATE INDEX IDX_Table1_DateCreated ON Table1(DateCreated);
CREATE INDEX IDX_Table2_Price ON Table2(Price);
CREATE INDEX IDX_Table3_IsActive ON Table3(IsActive);
CREATE INDEX IDX_Table4_LastLogin ON Table4(LastLogin);
CREATE INDEX IDX_Table5_OrderID ON Table5(OrderID);

-- 011
-- Consultas utilizando índices
SELECT * FROM Table1 WHERE DateCreated > DATEADD(DAY, -30, GETDATE());
SELECT * FROM Table2 WHERE Price > 50;
SELECT * FROM Table3 WHERE IsActive = 1;
SELECT * FROM Table4 WHERE LastLogin > DATEADD(DAY, -1, GETDATE());
SELECT * FROM Table5 WHERE OrderID BETWEEN 500 AND 1000;


--- Agregações complexas
-- 012
-- Funções de agregação complexas
SELECT 
    Category, 
    COUNT(*) AS CountItems, 
    AVG(Value) AS AvgValue, 
    SUM(Value) AS TotalValue 
FROM Table1 
GROUP BY Category;

SELECT 
    CreatedBy, 
    MIN(DateCreated) AS FirstCreation, 
    MAX(DateCreated) AS LastCreation 
FROM Table1 
GROUP BY CreatedBy;


-- 013
-- Criação e manipulação de tabelas temporárias em larga escala
CREATE TABLE #TempTable1 (ID INT, Value DECIMAL(18, 2));

INSERT INTO #TempTable1 (ID, Value)
SELECT ID, Value FROM Table1 WHERE Value > 500;

UPDATE #TempTable1 SET Value = Value * 1.05 WHERE ID % 2 = 0;

SELECT * FROM #TempTable1;

DROP TABLE #TempTable1;


-- 014
-- Junções complexas
SELECT 
    t1.ID, t1.Name, t2.Description, t3.Category, t4.Username, t5.Quantity, t5.Price 
FROM 
    Table1 t1
JOIN 
    Table2 t2 ON t1.ID = t2.ID
JOIN 
    Table3 t3 ON t1.ID = t3.ID
JOIN 
    Table4 t4 ON t1.ID = t4.ID
JOIN 
    Table5 t5 ON t1.ID = t5.ID;



/**********************************************************************************************/

-- IOPS
--015 Full Table Scan on Table1 with TOP 5000 rows
SELECT TOP 5000 *
FROM Table1 WITH (NOLOCK);

-- 016 Full Table Scan on Table2 with a WHERE clause that forces full scan
SELECT TOP 5000 *
FROM Table2
WHERE Price >= 0;  -- This condition will force a full scan

-- 017 Join between two large tables forcing a full scan
SELECT TOP 5000 *
FROM Table5 t5
JOIN Table7 t7 ON t5.OrderID = t7.ID
WHERE t5.Price >= 0;  -- This condition will force a full scan on both tables

-- 018 Cross Join between large tables forcing full scans
SELECT TOP 5000 *
FROM Table1 t1
CROSS JOIN Table2 t2
WHERE t1.Value >= 0 AND t2.Price >= 0;  -- This forces full scans on both tables

-- 019 Full Table Scan on multiple tables joined together
SELECT TOP 5000 *
FROM Table1 t1
JOIN Table2 t2 ON t1.ID = t2.ID
JOIN Table3 t3 ON t2.ID = t3.ID
JOIN Table4 t4 ON t3.ID = t4.ID
WHERE t1.Value >= 0 AND t2.Quantity >= 0 AND t3.IsActive = 1;  -- Full scans across all tables


---- CPU
-- 020 Complex aggregate functions across multiple columns
SELECT 
    SUM(Value) AS TotalValue,
    AVG(Value) AS AverageValue,
    MAX(Value) AS MaxValue,
    MIN(Value) AS MinValue,
    STDEV(Value) AS StdDevValue
FROM Table1;

-- 021 Intensive calculation with multiple joins and aggregates
SELECT 
    t1.Name,
    SUM(t1.Value * t5.Quantity) AS TotalSales,
    AVG(t2.Price * t7.TotalAmount) AS AvgTransactionValue
FROM Table1 t1
JOIN Table5 t5 ON t1.ID = t5.ProductID
JOIN Table7 t7 ON t5.OrderID = t7.ID
JOIN Table2 t2 ON t5.ProductID = t2.ID
GROUP BY t1.Name;

-- 022 Large case statements with multiple conditions
SELECT 
    t1.ID,
    CASE 
        WHEN t1.Value > 1000 THEN 'High'
        WHEN t1.Value > 500 THEN 'Medium'
        ELSE 'Low'
    END AS ValueCategory,
    CASE 
        WHEN t2.Quantity > 100 THEN 'Bulk'
        WHEN t2.Quantity > 50 THEN 'Medium'
        ELSE 'Small'
    END AS QuantityCategory
FROM Table1 t1
JOIN Table2 t2 ON t1.ID = t2.ID;

-- 023 Complex mathematical functions and nested aggregates
SELECT 
    t1.ID,
    EXP(SQRT(POWER(SUM(t1.Value), 2))) AS ComplexMath,
    LOG(ABS(SUM(t2.Price))) AS LogPriceSum
FROM Table1 t1
JOIN Table2 t2 ON t1.ID = t2.ID
GROUP BY t1.ID;

-- 024 Generating large result sets with many calculations
SELECT TOP 10000
    t1.ID,
    (SUM(t1.Value) + AVG(t2.Price) * COUNT(t3.ID)) / MAX(t4.ID) AS ComputedValue
FROM Table1 t1
JOIN Table2 t2 ON t1.ID = t2.ID
JOIN Table3 t3 ON t2.ID = t3.ID
JOIN Table4 t4 ON t3.ID = t4.ID
GROUP BY t1.ID;




-- Memo e TEMP DB
--  025 Large query with multiple derived tables and subqueries
SELECT TOP 5000 *
FROM (
    SELECT 
        t1.ID,
        t1.Name,
        SUM(t5.Quantity * t5.Price) OVER (PARTITION BY t1.ID ORDER BY t5.ID) AS RunningTotal
    FROM Table1 t1
    JOIN Table5 t5 ON t1.ID = t5.ProductID
) AS SubQuery;

-- 026 Large self-join with window functions
SELECT 
    t1.ID,
    t1.Value,
    LAG(t1.Value) OVER (ORDER BY t1.ID) AS PrevValue,
    LEAD(t1.Value) OVER (ORDER BY t1.ID) AS NextValue,
    SUM(t1.Value) OVER (ORDER BY t1.ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeSum
FROM Table1 t1;

-- 027 TempDB stress with large CTE and cross joins
WITH LargeCTE AS (
    SELECT *
    FROM Table2
    WHERE Price > 0
)
SELECT TOP 5000 *
FROM LargeCTE cte1
CROSS JOIN LargeCTE cte2
CROSS JOIN LargeCTE cte3;

-- 28 Heavy usage of sorting and grouping
SELECT 
    t1.ID,
    t2.Description,
    SUM(t5.Quantity * t5.Price) AS TotalSpent,
    AVG(t7.TotalAmount) AS AvgOrderValue
FROM Table1 t1
JOIN Table5 t5 ON t1.ID = t5.ProductID
JOIN Table7 t7 ON t5.OrderID = t7.ID
JOIN Table2 t2 ON t5.ProductID = t2.ID
GROUP BY 
    t1.ID, 
    t2.Description
ORDER BY 
    TotalSpent DESC,
    AvgOrderValue DESC;

-- 29 Large UNION ALL queries forcing temporary result sets
SELECT ID, Name, Value
FROM Table1
UNION ALL
SELECT ID, Description AS Name, Price AS Value
FROM Table2
UNION ALL
SELECT ID, Category AS Name, NULL AS Value
FROM Table3;


/*************************************************************************/
-- Full Table Scan com leitura de todas as colunas e agregação
SELECT TOP 5000 *
FROM Table1 t1
CROSS JOIN Table2 t2
CROSS JOIN Table3 t3
WHERE t1.Value >= 0
  AND t2.Quantity >= 0
  AND t3.IsActive = 1;

-- Junção pesada entre múltiplas tabelas com agregações e full scan
SELECT TOP 5000 t1.*, t5.*, t7.*
FROM Table1 t1
JOIN Table5 t5 ON t1.ID = t5.ProductID
JOIN Table7 t7 ON t5.OrderID = t7.ID
JOIN Table6 t6 ON t7.CustomerID = t6.ID
WHERE t1.Value >= 0 
  AND t5.Quantity >= 0 
  AND t6.City LIKE '%';

-- Cross Join ampliado forçando leituras e processamento massivo
SELECT TOP 5000 *
FROM Table1 t1
CROSS JOIN Table2 t2
CROSS JOIN Table3 t3
CROSS JOIN Table4 t4
WHERE t1.Value >= 0 
  AND t2.Quantity >= 0 
  AND t3.IsActive = 1
  AND t4.LastLogin IS NOT NULL;










-- Agregações com funções matemáticas complexas em várias colunas
SELECT 
    SUM(Value) + LOG(SUM(Value)) * SQRT(MAX(Value)) AS TotalValue,
    EXP(AVG(Value)) + POWER(MIN(Value), 2) AS ComputedValue,
    COS(SIN(SUM(Value))) * TAN(SQRT(SUM(Value))) AS TrigValue
FROM Table1;

-- Operações de agregação em junções complexas com funções matemáticas
SELECT 
    t1.Name,
    SUM(t1.Value * t5.Quantity) * LOG(ABS(SUM(t7.TotalAmount))) AS TotalSales,
    AVG(POWER(t2.Price * t7.TotalAmount, 3)) AS AvgTransactionValue,
    EXP(SUM(t1.Value)) / SUM(t5.Quantity) AS ExponentialValue
FROM Table1 t1
JOIN Table5 t5 ON t1.ID = t5.ProductID
JOIN Table7 t7 ON t5.OrderID = t7.ID
JOIN Table2 t2 ON t5.ProductID = t2.ID
GROUP BY t1.Name;

-- Complexo cálculo envolvendo subqueries e operações matemáticas
SELECT 
    t1.ID,
    CASE 
        WHEN SUM(t1.Value) > 1000 THEN EXP(SQRT(SUM(t1.Value)))
        WHEN SUM(t1.Value) > 500 THEN LOG(SUM(t1.Value) * SUM(t1.Value))
        ELSE POWER(SUM(t1.Value), 3)
    END AS ComputedValue
FROM Table1 t1
GROUP BY t1.ID;

-- Cálculos pesados utilizando várias tabelas e operações
SELECT 
    t1.ID,
    (SUM(t1.Value) + AVG(t2.Price) * COUNT(t3.ID)) / MAX(t4.ID) * SUM(t5.Quantity) AS ComputedValue
FROM Table1 t1
JOIN Table2 t2 ON t1.ID = t2.ID
JOIN Table3 t3 ON t2.ID = t3.ID
JOIN Table4 t4 ON t3.ID = t4.ID
JOIN Table5 t5 ON t1.ID = t5.ProductID
GROUP BY t1.ID;




















-- CTE com grande volume de dados e subqueries
WITH LargeCTE AS (
    SELECT t1.*, t2.Price, t3.Category, t4.LastLogin
    FROM Table1 t1
    JOIN Table2 t2 ON t1.ID = t2.ID
    JOIN Table3 t3 ON t2.ID = t3.ID
    JOIN Table4 t4 ON t3.ID = t4.ID
)
SELECT TOP 10000 
    cte1.*, 
    cte2.*, 
    SUM(cte1.Value * cte2.Price) OVER (PARTITION BY cte1.ID ORDER BY cte2.ID) AS RunningTotal
FROM LargeCTE cte1
JOIN LargeCTE cte2 ON cte1.ID = cte2.ID;

-- Junção complexa de várias CTEs
WITH CTE1 AS (
    SELECT ID, SUM(Value) AS TotalValue
    FROM Table1
    GROUP BY ID
), CTE2 AS (
    SELECT ID, SUM(Quantity) AS TotalQuantity
    FROM Table2
    GROUP BY ID
), CTE3 AS (
    SELECT ID, SUM(TotalAmount) AS TotalAmount
    FROM Table7
    GROUP BY ID
)
SELECT TOP 10000
    CTE1.ID,
    CTE1.TotalValue + CTE2.TotalQuantity * CTE3.TotalAmount AS ComplexCalculation
FROM CTE1
JOIN CTE2 ON CTE1.ID = CTE2.ID
JOIN CTE3 ON CTE2.ID = CTE3.ID;

-- Agregações com funções de janela (window functions)
SELECT 
    t1.ID,
    SUM(t1.Value) OVER (ORDER BY t1.ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeSum,
    AVG(t1.Value) OVER (ORDER BY t1.ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MovingAvg,
    MAX(t1.Value) OVER (ORDER BY t1.ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MovingMax,
    MIN(t1.Value) OVER (ORDER BY t1.ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS MovingMin
FROM Table1 t1
ORDER BY t1.ID;



----------------------------------------------------------------------------------------------------------
SELECT CONCAT(t1.Name, ' - ', t3.CreatedBy) AS UserInfo, 
       CONVERT(VARCHAR, t1.DateCreated, 23) AS DateCreatedFormatted, 
       t2.Description
FROM Table1 t1
JOIN Table3 t3 ON t1.Name LIKE '%única%' AND t3.CreatedBy LIKE '%usuário%'
JOIN Table2 t2 ON t2.Description LIKE '%descrição%';




SELECT UPPER(t4.Username) AS UpperUsername, 
       RTRIM(t6.City) AS TrimmedCity, 
       t6.State, 
       t8.ProductName
FROM Table4 t4
JOIN Table6 t6 ON t4.Username LIKE '%usuário%' AND t6.City LIKE '%çidade%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';



SELECT SUBSTRING(t2.Description, 1, 15) AS ShortDescription, 
       LTRIM(t6.Address) AS TrimmedAddress, 
       t1.Name, 
       t3.Category
FROM Table2 t2
JOIN Table6 t6 ON t6.Address LIKE '%endereço%'
JOIN Table1 t1 ON t1.Name LIKE '%única%'
JOIN Table3 t3 ON t3.Category LIKE '%categoría%';



SELECT LOWER(t1.Name) AS LowerName, 
       COALESCE(t4.LastLogin, '1900-01-01') AS LastLogin, 
       t8.ProductName
FROM Table1 t1
JOIN Table4 t4 ON t4.Username LIKE '%usuário%' 
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';



SELECT LEFT(t1.Name, 10) AS LeftName, 
       RIGHT(t3.CreatedBy, 5) AS RightCreatedBy, 
       t2.Description
FROM Table1 t1
JOIN Table3 t3 ON t3.CreatedBy LIKE '%usuário%'
JOIN Table2 t2 ON t2.Description LIKE '%descrição%';





SELECT UPPER(t6.City) AS CityUpper, 
       CAST(t6.ZipCode AS VARCHAR(10)) AS ZipCodeFormatted, 
       t1.Name, 
       t8.ProductName
FROM Table6 t6
JOIN Table1 t1 ON t1.Name LIKE '%única%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';





SELECT CONVERT(VARCHAR, t1.Value, 2) AS FormattedValue, 
       COALESCE(t4.Username, 'Unknown') AS Username, 
       t6.City
FROM Table1 t1
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.City LIKE '%çidade%';






SELECT LTRIM(RTRIM(t6.Address)) AS FullAddress, 
       CAST(t2.Price AS DECIMAL(18, 2)) AS FormattedPrice, 
       t3.CreatedBy, 
       t1.Name
FROM Table6 t6
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table3 t3 ON t3.CreatedBy LIKE '%usuário%'
JOIN Table1 t1 ON t1.Name LIKE '%única%';






SELECT SUBSTRING(t4.Username, 1, 5) AS UserInitials, 
       LEFT(t8.ProductName, 10) AS ShortProductName, 
       t3.Category
FROM Table4 t4
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%'
JOIN Table3 t3 ON t3.Category LIKE '%categoría%';





SELECT RIGHT(t6.State, 3) AS ShortState, 
       CONCAT(t1.Name, ' - ', t2.Description) AS NameDescription, 
       t4.Username
FROM Table6 t6
JOIN Table1 t1 ON t1.Name LIKE '%única%'
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table4 t4 ON t4.Username LIKE '%usuário%';




SELECT t1.Name, 
       CONVERT(VARCHAR(10), t1.DateCreated, 120) AS DateCreatedFormatted, 
       COALESCE(t6.Address, 'No Address') AS Address
FROM Table1 t1
JOIN Table6 t6 ON t6.Address LIKE '%endereço%'
WHERE t1.Name LIKE '%única%';





SELECT UPPER(t3.Category) AS CategoryUpper, 
       SUBSTRING(t4.Username, 1, 3) AS UserInitials, 
       RTRIM(t6.City) AS CityTrimmed
FROM Table3 t3
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.City LIKE '%çidade%';




SELECT LTRIM(t2.Description) AS DescriptionTrimmed, 
       RIGHT(t6.ZipCode, 5) AS ZipShort, 
       CAST(t8.StockQuantity AS VARCHAR(10)) AS StockQtyStr
FROM Table2 t2
JOIN Table6 t6 ON t6.ZipCode LIKE '%zíp%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';




SELECT CONCAT(t1.Name, ' - ', COALESCE(t2.Description, 'No Description')) AS FullDescription, 
       UPPER(t6.City) AS CityUpper
FROM Table1 t1
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table6 t6 ON t6.City LIKE '%çidade%';




SELECT LEFT(t3.Category, 5) AS ShortCategory, 
       CONVERT(VARCHAR(10), t4.LastLogin, 23) AS LastLoginFormatted, 
       LOWER(t8.ProductName) AS ProductLower
FROM Table3 t3
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';





SELECT CONCAT(t1.Name, ' - ', t3.Category) AS NameCategory,
       LTRIM(RTRIM(t4.Username)) AS TrimmedUsername,
       t2.Description, 
       t6.City, 
       t8.ProductName
FROM Table1 t1
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table3 t3 ON t3.Category LIKE '%categoría%'
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.City LIKE '%çidade%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';




SELECT UPPER(t1.Name) AS UpperName, 
       LOWER(t3.CreatedBy) AS LowerCreatedBy, 
       SUBSTRING(t2.Description, 1, 10) AS ShortDescription, 
       t4.Username, 
       t6.Address, 
       t8.ProductName
FROM Table1 t1
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table3 t3 ON t3.CreatedBy LIKE '%usuário%'
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.Address LIKE '%endereço%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';




SELECT LEFT(t1.Name, 5) AS LeftName, 
       RIGHT(t4.Username, 4) AS RightUsername, 
       COALESCE(t6.State, 'Unknown State') AS State, 
       t2.Description, 
       t3.Category, 
       t8.ProductName
FROM Table1 t1
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table3 t3 ON t3.Category LIKE '%categoría%'
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.State LIKE '%estádo%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';




SELECT CONVERT(VARCHAR(10), t1.Value, 1) AS FormattedValue, 
       CAST(t6.ZipCode AS VARCHAR(10)) AS ZipCodeFormatted, 
       LTRIM(t4.Username) AS TrimmedUsername, 
       t3.Category, 
       t2.Description, 
       t8.ProductName
FROM Table1 t1
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table3 t3 ON t3.Category LIKE '%categoría%'
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.ZipCode LIKE '%zíp%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';




SELECT CONCAT(t4.Username, ' - ', t3.CreatedBy) AS UserCreatedBy, 
       UPPER(t6.City) AS CityUpper, 
       LTRIM(t2.Description) AS TrimmedDescription, 
       t1.Name, 
       t8.ProductName
FROM Table1 t1
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table3 t3 ON t3.CreatedBy LIKE '%usuário%'
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.City LIKE '%çidade%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';





SELECT RTRIM(t6.Address) AS TrimmedAddress, 
       SUBSTRING(t2.Description, 1, 15) AS ShortDescription, 
       COALESCE(t3.Category, 'No Category') AS Category, 
       t1.Name, 
       t4.Username, 
       t8.ProductName
FROM Table1 t1
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table3 t3 ON t3.Category LIKE '%categoría%'
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.Address LIKE '%endereço%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';



SELECT LOWER(t3.CreatedBy) AS CreatedByLower, 
       LEFT(t1.Name, 7) AS ShortName, 
       CONVERT(VARCHAR, t4.LastLogin, 23) AS LastLoginFormatted, 
       t2.Description, 
       t6.City, 
       t8.ProductName
FROM Table1 t1
JOIN Table2 t2 ON t2.Description LIKE '%descrição%'
JOIN Table3 t3 ON t3.CreatedBy LIKE '%usuário%'
JOIN Table4 t4 ON t4.Username LIKE '%usuário%'
JOIN Table6 t6 ON t6.City LIKE '%çidade%'
JOIN Table8 t8 ON t8.ProductName LIKE '%prodúto%';


/**************************************************************************************************/
/**************************************************************************************************/
WITH NumberExtractionT1 AS (
    SELECT t1.ID,
           t1.name,
           (SELECT '' + SUBSTRING(t1.name, n, 1)
            FROM (SELECT TOP (LEN(t1.name)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                  FROM sys.all_objects) AS Numbers
            WHERE SUBSTRING(t1.name, n, 1) LIKE '[0-9]'
            FOR XML PATH('')) AS OnlyNumbersT1
    FROM table1 t1
),
NumberExtractionT2 AS (
    SELECT t2.ID,
           t2.Description,
           (SELECT '' + SUBSTRING(t2.Description, n, 1)
            FROM (SELECT TOP (LEN(t2.Description)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                  FROM sys.all_objects) AS Numbers
            WHERE SUBSTRING(t2.Description, n, 1) LIKE '[0-9]'
            FOR XML PATH('')) AS OnlyNumbersT2
    FROM table2 t2
),
NumberExtractionT3 AS (
    SELECT t3.ID,
           t3.Category,
           (SELECT '' + SUBSTRING(t3.Category, n, 1)
            FROM (SELECT TOP (LEN(t3.Category)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                  FROM sys.all_objects) AS Numbers
            WHERE SUBSTRING(t3.Category, n, 1) LIKE '[0-9]'
            FOR XML PATH('')) AS OnlyNumbersT3
    FROM table3 t3
),
NumberExtractionT4 AS (
    SELECT t4.ID,
           t4.Username,
           (SELECT '' + SUBSTRING(t4.Username, n, 1)
            FROM (SELECT TOP (LEN(t4.Username)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                  FROM sys.all_objects) AS Numbers
            WHERE SUBSTRING(t4.Username, n, 1) LIKE '[0-9]'
            FOR XML PATH('')) AS OnlyNumbersT4
    FROM table4 t4
),
NumberExtractionT6 AS (
    SELECT t6.ID,
           t6.Address,
           (SELECT '' + SUBSTRING(t6.Address, n, 1)
            FROM (SELECT TOP (LEN(t6.Address)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                  FROM sys.all_objects) AS Numbers
            WHERE SUBSTRING(t6.Address, n, 1) LIKE '[0-9]'
            FOR XML PATH('')) AS OnlyNumbersT6
    FROM table6 t6
),
NumberExtractionT8 AS (
    SELECT t8.ID,
           t8.ProductName,
           (SELECT '' + SUBSTRING(t8.ProductName, n, 1)
            FROM (SELECT TOP (LEN(t8.ProductName)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                  FROM sys.all_objects) AS Numbers
            WHERE SUBSTRING(t8.ProductName, n, 1) LIKE '[0-9]'
            FOR XML PATH('')) AS OnlyNumbersT8
    FROM table8 t8
)
-- Realiza o JOIN entre todas as tabelas usando os números extraídos
SELECT 
    t1.ID AS ID_T1, t1.name AS Name, 
    t2.ID AS ID_T2, t2.Description AS Description, 
    t3.ID AS ID_T3, t3.Category AS Category,
    t4.ID AS ID_T4, t4.Username AS Username,
    t6.ID AS ID_T6, t6.Address AS Address,
    t8.ID AS ID_T8, t8.ProductName AS ProductName
FROM NumberExtractionT1 t1
JOIN NumberExtractionT2 t2 ON t1.OnlyNumbersT1 = t2.OnlyNumbersT2
JOIN NumberExtractionT3 t3 ON t2.OnlyNumbersT2 = t3.OnlyNumbersT3
JOIN NumberExtractionT4 t4 ON t3.OnlyNumbersT3 = t4.OnlyNumbersT4
JOIN NumberExtractionT6 t6 ON t4.OnlyNumbersT4 = t6.OnlyNumbersT6
JOIN NumberExtractionT8 t8 ON t6.OnlyNumbersT6 = t8.OnlyNumbersT8
WHERE t1.OnlyNumbersT1 IS NOT NULL
  AND t2.OnlyNumbersT2 IS NOT NULL
  AND t3.OnlyNumbersT3 IS NOT NULL
  AND t4.OnlyNumbersT4 IS NOT NULL
  AND t6.OnlyNumbersT6 IS NOT NULL
  AND t8.OnlyNumbersT8 IS NOT NULL;










