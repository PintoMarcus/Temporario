"SCRAM-SHA-256$4096:xcuMr8zROFyEsb37fsNbaw==$6lAYUceaibF/MSTf+GIjirFVxqHB2GAxBOR+0bKiCuY=:c7XRl9hHvTOmOn8Qq4g6+BDM3ue4tvMMt+7le0S4eDE="

-- gera o hash do usuário na instância de origem
SELECT password FROM pg_shadow WHERE usename = 'seu_usuario';
SELECT pg_shadow.passwd FROM pg_shadow WHERE usename = 'seu_usuario';

-- altera o hash pwd do usuário na instância de destino.
ALTER USER seu_usuario PASSWORD 'hash_da_senha_da_instancia_01';

--
--- Cria usuário com senha
SELECT 'CREATE USER ' || usename || ' WITH PASSWORD ''' || passwd || ''';'
FROM pg_shadow
WHERE usename IN ('user-01','usr02');

