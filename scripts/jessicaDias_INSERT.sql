-- Nome, website, sigla(PK) 
INSERT INTO campus VALUES ('Universidade Federal de S�o Carlos', 'http://www2.ufscar.br/home/index.php', 'UFSCARSC', '16 3216-8520',, 'Rua dos passarinho 2');

-- Nome, website, ponto geogr�fico(varchar), sigla(PK) 
INSERT INTO centro VALUES ('Centro de Ci�ncias Exatas e de Tecnologia', 'http://www.ccet.ufscar.br/', '10,10', 'CCET', '16 3315-8888');

-- Nome, website, sigla(PK), sigla_campus(FK) 
INSERT INTO departamento VALUES ('Computa��o', 'http://www2.ufscar.br/home/index.php', 'DC', '16 3414-6582',, 'Estrada Highway to Hell 666', 'CCET');

-- N�mero de cr�ditos, nome (PK) 
INSERT INTO atcomp VALUES (60, 'Inicia��o Cient�fica');

-- Ra estudante(FK), Nome da atividade complementar(FK),  
INSERT INTO realizaace VALUES ('1234', 'Inicia��o Cient�fica');