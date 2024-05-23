
-- Criar a tabela CharMap
CREATE TABLE CharMap (
    OriginalChar CHAR(1) PRIMARY KEY,
    Variations NVARCHAR(MAX)
);

-- Inserir dados na tabela CharMap
INSERT INTO CharMap (OriginalChar, Variations) VALUES
('a', 'aáàâãäAÁÀÂÃÄ'),
('e', 'eéèêëEÉÈÊË'),
('i', 'iíìîïIÍÌÎÏ'),
('o', 'oóòôõöOÓÒÔÕÖ'),
('u', 'uúùûüUÚÙÛÜ'),
('c', 'cçCÇ'),
('t', 'tT');

-- Procedure
CREATE PROCEDURE GenerateCombinations
    @inputString NVARCHAR(7)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar se a string de entrada tem exatamente 7 caracteres
    IF LEN(@inputString) <> 7
    BEGIN
        RAISERROR('Input string must be exactly 7 characters long.', 16, 1);
        RETURN;
    END

    DECLARE @len INT = LEN(@inputString);
    DECLARE @combinations TABLE (Combo NVARCHAR(7));

    -- Inicialize a tabela de combinações com uma entrada inicial
    INSERT INTO @combinations (Combo) VALUES ('');

    -- Iterar sobre cada caractere da string de entrada
    DECLARE @i INT = 1;

    WHILE @i <= @len
    BEGIN
        DECLARE @currentChar CHAR(1) = SUBSTRING(@inputString, @i, 1);
        DECLARE @variations NVARCHAR(MAX);

        -- Obter as variações do caractere atual
        SELECT @variations = Variations
        FROM CharMap
        WHERE OriginalChar = @currentChar;

        -- Se não houver variações, usar o caractere original
        IF @variations IS NULL
        BEGIN
            SET @variations = @currentChar;
        END

        -- Gerar novas combinações adicionando as variações do caractere atual na posição correta
        DECLARE @temp TABLE (Combo NVARCHAR(7));
        INSERT INTO @temp (Combo)
        SELECT LEFT(c.Combo, @i - 1) + v.CharValue + RIGHT(@inputString, @len - @i)
        FROM @combinations c
        CROSS APPLY (
            SELECT SUBSTRING(@variations, number, 1) AS CharValue
            FROM master.dbo.spt_values
            WHERE type = 'P' AND number BETWEEN 1 AND LEN(@variations)
        ) v;

        -- Substituir as combinações antigas pelas novas
        DELETE FROM @combinations;
        INSERT INTO @combinations (Combo)
        SELECT DISTINCT Combo FROM @temp;

        SET @i = @i + 1;
    END

    -- Retornar o resultado
    SELECT Combo FROM @combinations;
END;
GO

-- Testar o procedimento armazenado com a string de entrada 'taeiouc'
EXEC GenerateCombinations 'taeiouc';
