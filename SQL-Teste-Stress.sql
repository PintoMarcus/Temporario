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



