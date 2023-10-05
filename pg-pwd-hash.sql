-- gera o hash do usuário na instância de origem
SELECT password FROM pg_shadow WHERE usename = 'seu_usuario';

-- altera o hash pwd do usuário na instância de destino.
ALTER USER seu_usuario PASSWORD 'hash_da_senha_da_instancia_01';

