DECLARE @StartTime DATETIME = GETDATE();
DECLARE @EndTime DATETIME = DATEADD(MINUTE, 10, @StartTime);

-- Aguarda por 10 minutos
WHILE GETDATE() < @EndTime
BEGIN
    -- Consulta vazia
    SELECT 1;
END;
