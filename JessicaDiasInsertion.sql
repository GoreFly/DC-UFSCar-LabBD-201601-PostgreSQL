-- Nome, website, sigla(PK) 
INSERT INTO campus VALUES ('Universidade Federal de S�o Carlos', 'http://www2.ufscar.br/home/index.php', 'UFSCARSC');

-- Nome, website, ponto geogr�fico(varchar), sigla(PK) 
INSERT INTO centro VALUES ('Centro de Ci�ncias Exatas e de Tecnologia', 'http://www.ccet.ufscar.br/', '10,10' ,'CCET');

-- Nome, website, sigla(PK), sigla_campus(FK) 
INSERT INTO departamento VALUES ('Computa��o', 'http://www2.ufscar.br/home/index.php', 'DC', 'CCET');

-- N�mero de cr�ditos, nome (PK) 
INSERT INTO atcomp VALUES (60, 'Inicia��o Cient�fica');

-- Ra estudante(FK), Nome da atividade complementar(FK),  
INSERT INTO realizaace VALUES ('1234', 'Inicia��o Cient�fica');