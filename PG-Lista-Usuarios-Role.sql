-- Lista os usuários de uma role específica
-- no exemplo usamos a role sysadmin

SELECT rolname
FROM pg_user
WHERE usesysid IN (
    SELECT member
    FROM pg_auth_members
    WHERE roleid = (
        SELECT oid
        FROM pg_roles
        WHERE rolname = 'sysadmin'
    )
);
