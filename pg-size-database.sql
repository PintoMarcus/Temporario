SELECT
  schema_name,
  pg_size_pretty(total_size) AS "Tamanho Total do Schema"
FROM (
  SELECT
    nspname AS schema_name,
    sum(pg_total_relation_size(quote_ident(nspname) || '.' || quote_ident(relname))) AS total_size
  FROM pg_class
  JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace
  GROUP BY nspname
) AS schema_sizes;
