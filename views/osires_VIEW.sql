
-- Laboratorio de Banco de Dados
-- Nome: Osires Fernando Ribeiro Nhaga     RA: 574430



-- views que mostra alguns dados somente das pessoas que s�o docentes.

drop view V_Docente; 

create view V_Docente as 
select ultimo_nome, email, sexo, origem_pais, codigo
from 
Pessoa
inner join
Docente on 
Pessoa.rg = Docente.pessoa_rg

=================================================================

-- views que mostra alguns dados somente das pessoas que s�o Tecnicos Administrativos.

drop view V_TecAdm; 

create view V_TecAdm as 
select ultimo_nome, email, sexo, origem_pais, codigo
from 
Pessoa
inner join
TecADM on 
Pessoa.rg = TecADM.pessoa_rg


=================================================================

-- views que mostra alguns dados somente dos docentes que pertencem ao Nucleo Docente.


drop view V_PertenceDND; 

create view V_PertenceDND as 
select ultimo_nome, email, sexo, origem_pais, docente_codigo, nucleodocente_codigo, periodo
from 
Pessoa
inner join
Docente on 
Pessoa.rg = Docente.pessoa_rg
inner join 
PertenceDND on
Docente.codigo = PertenceDND.docente_codigo
















