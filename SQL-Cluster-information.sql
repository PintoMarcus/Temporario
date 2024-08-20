--001
-- Verifica os nós que fazem parte do cluster e sua função
SELECT 
    cs.virtual_server_name AS ClusterName,
    cs.instance_name AS SQLInstanceName,
    n.node_name AS NodeName,
    n.status_description AS NodeStatus,
    cs.active_start_date AS InstallDate
FROM 
    sys.dm_os_cluster_nodes AS n
INNER JOIN 
    sys.dm_os_cluster_servers AS cs 
    ON cs.node_name = n.node_name;

-- Verifica o status do cluster
SELECT 
    cluster_name, 
    quorum_type_desc, 
    quorum_state_desc, 
    NumberOfNodes, 
    NumberOfVotingNodes 
FROM 
    sys.dm_hadr_cluster;



--002
-- Verifica o status de cada instância do SQL Server no cluster
SELECT 
    serverproperty('MachineName') AS NodeName,
    serverproperty('IsClustered') AS IsClustered, 
    serverproperty('ComputerNamePhysicalNetBIOS') AS ActiveNode,
    serverproperty('InstanceName') AS InstanceName,
    serverproperty('Edition') AS Edition,
    serverproperty('ProductVersion') AS ProductVersion;


--003
-- Verifica a configuração de Database Mirroring
SELECT 
    db_name(database_id) AS DatabaseName,
    mirroring_state_desc,
    mirroring_role_desc,
    mirroring_partner_name,
    mirroring_partner_instance,
    mirroring_witness_name
FROM 
    sys.database_mirroring;


--004
-- Verifica os Grupos de Disponibilidade configurados
SELECT 
    ag.name AS AGName,
    ar.replica_server_name AS ReplicaServerName,
    ar.availability_mode_desc AS AvailabilityMode,
    ar.failover_mode_desc AS FailoverMode,
    ar.primary_role_allow_connections_desc AS PrimaryRoleConnections,
    ar.secondary_role_allow_connections_desc AS SecondaryRoleConnections,
    ars.role_desc AS CurrentRole,
    ars.connected_state_desc AS ConnectionState
FROM 
    sys.availability_replicas AS ar
JOIN 
    sys.availability_groups AS ag 
    ON ar.group_id = ag.group_id
JOIN 
    sys.dm_hadr_availability_replica_states AS ars 
    ON ar.replica_id = ars.replica_id;

-- Verifica o status dos bancos de dados nos Grupos de Disponibilidade
SELECT 
    ag.name AS AGName,
    db_name(drs.database_id) AS DatabaseName,
    drs.synchronization_state_desc AS SyncState,
    drs.is_suspended AS IsSuspended,
    drs.recovery_health_desc AS RecoveryState,
    drs.synchronization_health_desc AS SyncHealth
FROM 
    sys.dm_hadr_database_replica_states AS drs
JOIN 
    sys.availability_groups AS ag 
    ON drs.group_id = ag.group_id;


--005
-- Verifica as publicações configuradas para replicação
SELECT 
    p.publisher AS Publisher,
    p.publisher_db AS PublisherDB,
    p.publication AS PublicationName,
    p.repl_freq AS ReplicationFrequency,
    p.status AS PublicationStatus,
    p.retention AS RetentionPeriod
FROM 
    distribution.dbo.MSpublications AS p;

-- Verifica os assinantes da replicação
SELECT 
    s.srvname AS SubscriberServer,
    d.name AS SubscriberDB,
    a.subscriber_id,
    a.subscriber_db,
    a.subscription_type,
    a.subscription_status,
    a.last_sync_status,
    a.last_sync_summary,
    a.last_sync_time
FROM 
    distribution.dbo.MSsubscriptions AS a
JOIN 
    sysservers AS s 
    ON a.subscriber_id = s.srvid
JOIN 
    sys.databases AS d 
    ON a.subscriber_db = d.name;


