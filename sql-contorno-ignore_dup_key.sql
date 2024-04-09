-- Possível solução para mitigar o ignore_dup_key = on usar uma tabela temporária para armazenar os registros que você deseja inserir e, em seguida, fazer a inserção final com uma cláusula WHERE que exclua os registros duplicados da tabela temporária.


-- Crie uma tabela temporária para armazenar os registros que você deseja inserir
CREATE TABLE #TempWorkerTable (
    Tipo VARCHAR(50) NOT NULL,
    id_txt INT NOT NULL,
    produto VARCHAR(500) NOT NULL,
    Datacriacao DATETIME NOT NULL,
    PRIMARY KEY (Tipo, id_txt, produto, Datacriacao)
);

-- Faça a inserção dos registros desejados na tabela temporária
INSERT INTO #TempWorkerTable (Tipo, id_txt, produto, Datacriacao)
SELECT DISTINCT 'Empresa-Renda' AS Tipo,
                ID_TXT,
                E.DZ AS produto,
                Datacriacao
FROM TB_SV9_1 AS E
JOIN TB_SV9_2 AS PlanosNovos ON PlanosNovos.produto IN (E.DZ, E.EB, E.ED)
WHERE CONVERT(DATE, Datacriacao) BETWEEN @DataInicio AND @DataFim;

-- Faça a inserção final na tabela #worker_table, excluindo registros duplicados
INSERT INTO #worker_table (Tipo, id_txt, produto, Datacriacao)
SELECT Tipo, id_txt, produto, Datacriacao
FROM #TempWorkerTable AS twt
WHERE NOT EXISTS (
    SELECT 1
    FROM #worker_table AS wt
    WHERE wt.Tipo = twt.Tipo
        AND wt.id_txt = twt.id_txt
        AND wt.produto = twt.produto
        AND wt.Datacriacao = twt.Datacriacao
);

-- Exclua a tabela temporária quando terminar
DROP TABLE #TempWorkerTable;


------------------------
-- EXEMPLO 02 Testado:

-- Imagine a tabela:
  use sv9;
SET ANSI_NULLS ON 
GO 
SET QUOTED_IDENTIFIER ON 
GO 
CREATE TABLE [dbo]. [TB_SV9_02]( 
[CD_CODIGO_COTA] [varchar](50) NOT NULL, 
[DT_DATA_COTA] [date] NOT NULL, 
[DT_DATA_ALTERACAO] [datetime] NOT NULL, 
[DS_COMENTARIO] [varchar](250) NOT NULL, 
[DS_USER] [varchar](100) NOT NULL,

CONSTRAINT [PK_TB_SV9_02] 
PRIMARY KEY CLUSTERED (
[CD_CODIGO_COTA] ASC, 
[DT_DATA_COTA] ASC, 
[DT_DATA_ALTERACAO] ASC			

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE =	OFF, IGNORE_DUP_KEY	= OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]	
)ON [PRIMARY]	
go

---------
-- Crie uma tabela temporária para armazenar os registros únicos
CREATE TABLE #UniqueRecords (
    CD_CODIGO_COTA VARCHAR(50) NOT NULL,
    DT_DATA_COTA DATE NOT NULL,
    DT_DATA_ALTERACAO DATETIME NOT NULL,
    DS_COMENTARIO VARCHAR(250) NOT NULL,
    DS_USER VARCHAR(100) NOT NULL
);

-- Inserção na tabela temporária apenas dos registros que não existem na tabela alvo
INSERT INTO #UniqueRecords (CD_CODIGO_COTA, DT_DATA_COTA, DT_DATA_ALTERACAO, DS_COMENTARIO, DS_USER)
VALUES
    ('Codigo1', '2023-10-29', GETDATE(), 'Comentário #101', 'User #101'),
    ('Codigo1', '2023-10-29', GETDATE(), 'Comentário #102', 'User #102'),
    ('Codigo1', '2023-10-29', GETDATE(), 'Comentário #103', 'User #103');

DECLARE @Count INT = 1;
DECLARE @TotalRows INT = (SELECT COUNT(*) FROM #UniqueRecords);

-- Loop para inserir cada registro individualmente
WHILE @Count <= @TotalRows
BEGIN
    BEGIN TRY
        DECLARE @CD_CODIGO_COTA VARCHAR(50);
        DECLARE @DT_DATA_COTA DATE;
        DECLARE @DT_DATA_ALTERACAO DATETIME;
        DECLARE @DS_COMENTARIO VARCHAR(250);
        DECLARE @DS_USER VARCHAR(100);

        -- Obtenha os valores da tabela temporária
        SELECT @CD_CODIGO_COTA = CD_CODIGO_COTA,
               @DT_DATA_COTA = DT_DATA_COTA,
               @DT_DATA_ALTERACAO = DT_DATA_ALTERACAO,
               @DS_COMENTARIO = DS_COMENTARIO,
               @DS_USER = DS_USER
        FROM (
            SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
            FROM #UniqueRecords
        ) AS tmp
        WHERE RowNum = @Count;

        -- Verifique se o registro já existe na tabela alvo
        IF NOT EXISTS (
            SELECT 1
            FROM [dbo].[TB_SV9_02]
            WHERE CD_CODIGO_COTA = @CD_CODIGO_COTA
              AND DT_DATA_COTA = @DT_DATA_COTA
              AND DT_DATA_ALTERACAO = @DT_DATA_ALTERACAO
              AND DS_COMENTARIO = @DS_COMENTARIO
              AND DS_USER = @DS_USER
        )
        BEGIN
            -- Insira o registro na tabela alvo
            INSERT INTO [dbo].[TB_SV9_02] (CD_CODIGO_COTA, DT_DATA_COTA, DT_DATA_ALTERACAO, DS_COMENTARIO, DS_USER)
            VALUES (@CD_CODIGO_COTA, @DT_DATA_COTA, @DT_DATA_ALTERACAO, @DS_COMENTARIO, @DS_USER);
        END
    END TRY
    BEGIN CATCH
        -- Capture e ignore o erro de violação de chave primária
    END CATCH;

    -- Atualize o contador
    SET @Count = @Count + 1;
END;

-- Exclua a tabela temporária quando terminar
DROP TABLE #UniqueRecords;


