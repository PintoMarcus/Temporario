-- Objetivo: subsituir as vogais por 0 1 2 3 4 e as demais consoantes por X

UPDATE minha-tabela
SET minha-coluna = TRANSLATE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Nm, 'A', '0'), 'E', '1'), 'I', '2'), 'O', '3'), 'U', '4'), 'BCDFGHJKLMNPQRSTVWXYZ', 'XXXXXXXXXXXXXXX')
