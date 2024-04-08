-- Verifica se a instância está configurada como Failover Cluster
IF SERVERPROPERTY('IsClustered') = 1
BEGIN
    PRINT 'A instância está configurada como Failover Cluster.'
END
ELSE
BEGIN
    PRINT 'A instância não está configurada como Failover Cluster.'
END

-- Verifica se a instância está configurada com AlwaysOn Availability Groups
IF EXISTS (
    SELECT 1
    FROM sys.dm_hadr_cluster
)
BEGIN
    PRINT 'A instância está configurada com AlwaysOn Availability Groups.'
END
ELSE
BEGIN
    PRINT 'A instância não está configurada com AlwaysOn Availability Groups.'
END
