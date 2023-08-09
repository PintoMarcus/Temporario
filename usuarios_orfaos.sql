--lista usuários órfãos
CREATE TABLE ##ORPHANUSER 
( 
DBNAME VARCHAR(100), 
USERNAME VARCHAR(100), 
CREATEDATE VARCHAR(100), 
USERTYPE VARCHAR(100) 
) 
 
EXEC SP_MSFOREACHDB' USE [?] 
INSERT INTO ##ORPHANUSER 
SELECT DB_NAME() DBNAME, NAME,CREATEDATE, 
(CASE  
WHEN ISNTGROUP = 0 AND ISNTUSER = 0 THEN ''SQL LOGIN'' 
WHEN ISNTGROUP = 1 THEN ''NT GROUP'' 
WHEN ISNTGROUP = 0 AND ISNTUSER = 1 THEN ''NT LOGIN'' 
END) [LOGIN TYPE] FROM sys.sysusers 
WHERE SID IS NOT NULL AND SID <> 0X0 AND ISLOGIN =1 AND 
SID NOT IN (SELECT SID FROM sys.syslogins)' 
 
SELECT * FROM ##ORPHANUSER 
 
DROP TABLE ##ORPHANUSER 



----lista logins
SELECT 
    name AS 'User'
  , PRINCIPAL_ID
  , type AS 'User Type'
  , type_desc AS 'Login Type'
  , CAST(create_date AS DATE) AS 'Date Created' 
  , default_database_name AS 'Database Name'
  
FROM master.sys.server_principals
WHERE type LIKE 's' OR type LIKE 'u'
ORDER BY [User]; 
GO