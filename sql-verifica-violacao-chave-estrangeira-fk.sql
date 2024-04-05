-- Verifica violação de chave estrangeira
/*
Para identificar os registros que violam a chave estrangeira ao tentar recriar a constraint, você pode executar uma consulta que verifique se existem registros na tabela tb1 que não têm correspondência na tabela referenciada tb2.
Aqui está um exemplo de como você pode fazer isso:

Essa consulta seleciona os registros da tabela tb1 que não possuem correspondência na tabela referenciada tb2, ou seja, os registros que violariam a chave estrangeira ao tentar recriar a constraint. 
Certifique-se de substituir dbo.tb1 e dbo.tb2 pelos nomes reais das suas tabelas.
*/

SELECT tb1.cd_empresa, tb1.nr_emissao, tb1.Nr_serie
FROM dbo.tb1
LEFT JOIN dbo.tb2 ON tb1.cd_empresa = tb2.cd_empresa 
                 AND tb1.nr_emissao = tb2.nr_emissao 
                 AND tb1.Nr_serie = tb2.Nr_serie
WHERE tb2.cd_empresa IS NULL
