SELECT 
    name AS 'LoginName',
    is_policy_checked AS 'PasswordPolicyEnforced',
    is_expiration_checked AS 'PasswordExpirationEnforced',
    create_date AS 'CreateDate',
    modify_date AS 'ModifyDate',
	is_disabled AS 'IsDisabled',
	 LOGINPROPERTY(name, 'IsLocked') AS 'IsLocked',
    LOGINPROPERTY(name, 'DaysUntilExpiration') AS 'DaysUntilExpiration'
FROM sys.sql_logins
WHERE name = 'teste3';
