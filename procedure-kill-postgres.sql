CREATE OR REPLACE FUNCTION kill_session(IN spid INT)
RETURNS VOID AS $$
BEGIN
  -- Encerra a sessão com o SPID fornecido
  PERFORM pg_terminate_backend(spid);
END;
$$ LANGUAGE plpgsql;
