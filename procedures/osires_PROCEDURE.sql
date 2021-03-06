-- Laboratorio de Banco de Dados
-- Nome: Osires Fernando Ribeiro Nhaga     RA: 574430


-- Procedure para alterar codigo de um Tecnico Administrativo

Drop Function alterarCodigoT(codigoact in integer, newcodigo integer);

CREATE OR REPLACE FUNCTION alterarCodigoT(codigoact in integer, newcodigo integer)
RETURNS void AS 
$$
BEGIN
  UPDATE TecADM
  SET codigo=newcodigo
  WHERE TecADM.codigo=codigoact;
END;
$$
LANGUAGE plpgsql;

-------

select alterarCodigoT(221525208, 25252525);

