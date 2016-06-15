---------------------
------- TIPOS -------
---------------------

CREATE TYPE telefone AS 
(
    origem character varying(20),
    tipo character varying(20),
    ramal integer,
    ddd integer,
    fone bigint 
);

CREATE TYPE coord AS 
(
    nome character varying(40),
    telefone telefone
);

CREATE TYPE endereco AS 
(
    rua character varying(50),
    complemento character varying(20),
    bairro character varying(20),
    cidade character varying(20),
    uf character varying(2),
    pais character varying(20),
    cep bigint 
);

CREATE TYPE gradecurricular AS 
(
	Optativa boolean,
	Obrigatoria boolean,
	Eletiva boolean
);

CREATE TYPE supervisor AS 
(
    cpf bigint,
    nome character varying(30)
);





---------------------
----- ENTIDADES -----
---------------------

-- ATIVIDADE COMPLEMENTAR
CREATE TABLE AtComp
(
  	creditos integer,
  	nome character varying(100) NOT NULL,

  	CONSTRAINT AtComp_pk PRIMARY KEY (nome)
);

-- RECONHECIMENTO DE CURSO
CREATE TABLE ReconhecimentoDeCurso 
(
	codigo character varying(10) not null,

	CONSTRAINT ReconhecimentoDeCurso_pk PRIMARY KEY (codigo)
);

-- CAMPUS
CREATE TABLE Campus
(
	nome character varying(50),
	website character varying(100),
 	sigla character varying(10) NOT NULL,
  	telefone1 character varying(20) NOT NULL,
 	telefone2 character varying(20),
 	endereco character varying(100) NOT NULL,

 	CONSTRAINT Campus_pk PRIMARY KEY (sigla)
);
 
-- CENTRO
CREATE TABLE Centro
(
  	nome character varying(50),
  	website character varying(100),
  	geo character varying(50),
  	sigla character varying(10) NOT NULL,
  	telefone1 character varying(20) NOT NULL,
  	telefone2 character varying(20),

  	CONSTRAINT Centro_pk PRIMARY KEY (sigla)
);

-- CONSELHO DE CURSO
CREATE TABLE ConselhoCurso
(  
	representante character varying(20),
	id integer not null,

	CONSTRAINT ConselhoCurso_pk PRIMARY KEY (id) 
);

-- CURSO
CREATE TABLE Curso 
(
    codigo integer constraint Curso_pk primary key,
    website character varying(40),
    nome character varying(40),
    coordenador coord 
);

-- DISCIPLINA
CREATE TABLE Disciplina 
(
	codigo character varying(10) CONSTRAINT Disciplina_PK primary key,
	sigla character varying(7),
	nro_creditos integer,
	vezes_Realizadas integer,
	categoria character varying(20)	
);

-- EMPRESA
CREATE TABLE Empresa 
(
    cnpj bigint constraint Empresa_pk primary key,
    nome integer,
    endereco endereco
);

-- PESSOA
CREATE TABLE Pessoa 
(
	rg character varying(9) not null,
	pre_nome character varying(20),
	meio_nome character varying(20),
	ultimo_nome character varying(20),
	email character varying(20),
	email_institucional character varying(20),
	etnia character varying(15),
	sexo char,
	data_nascimento date,
	nome_mae character varying(20),
	nome_pai character varying(20),
	origem_cidade character varying(20),
	origem_estado character varying(20),
	origem_pais character varying(20),
	nacionalidade character varying(15),
	endereco endereco,
	telefone telefone,
  
  CONSTRAINT Pessoa_pk PRIMARY KEY (rg)
);

-- NUCLEO DOCENTE
CREATE TABLE NucleoDocente
(  
	Presidente character varying(20),
	codigo integer not null,

	CONSTRAINT NucleoDocente_pk PRIMARY KEY (codigo) 
);

-- ESTUDANTE
CREATE TABLE Estudante 
(
	ra integer CONSTRAINT Estudante_PK  primary key,
	cpf character varying(15) NOT NULL UNIQUE,
	anoConcEM character varying(4),
	ira integer NOT NULL,
	presencial char, -- atributo descriminatório: Presencial(s) ou Distancia(n) (7.2.1 - C Elmasri)
	graduando boolean, -- Flag de reconhecimento Estudante Graduando
	posGraduando boolean -- Flag de reconhecimento Estudante Pós Graduando(7.2.1 - D Elmasri)
);

-- REUNIÃO
CREATE TABLE Reuniao 
(
	numero integer not null unique,
	pauta text,
	data_inicio date,

	CONSTRAINT Reuniao_pk PRIMARY KEY (numero)
);

-- CALENDÁRIO
CREATE TABLE Calendario 
(
	data_inicio date not null,
	data_fim date,
	dias_letivos integer not null,
	tipo char not null, -- atributo discriminatório Graduação Presencial (p), EaD (e) ou Administrativo (a)
	aprovado boolean default false,
	reuniao_numero integer,
	anterior_data date,	-- data de início do calendário anterior ao referente
	anterior_tipo char, -- tipo do calendário anterior ao referente

	CONSTRAINT Calendario_Reuniao_fk FOREIGN KEY (reuniao_numero) REFERENCES Reuniao(numero)
		ON DELETE RESTRICT,
	CONSTRAINT Calendario_pk PRIMARY KEY (data_inicio, tipo)
);

-- EVENTO
CREATE TABLE Evento 
(
	id_evento serial not null unique,
	data_inicio date not null,
	data_fim date,
	descricao text,
	calendario_data date not null, -- data de início do calendario ao qual o evento pertence
	calendario_tipo char, -- tipo do calendario ao qual o eento pertence

	CONSTRAINT Evento_Calendario_fk FOREIGN KEY (calendario_data, calendario_tipo) REFERENCES Calendario(data_inicio, tipo)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT Evento_pk PRIMARY KEY (calendario_data, calendario_tipo, id_evento)
);

------ define o auto-relacionamento entre Calendário "anterior" e Calendário "posterior"
ALTER TABLE Calendario ADD FOREIGN KEY (anterior_data, anterior_tipo) REFERENCES Calendario(data_inicio, tipo);

------ trigger para calcular data_fim
CREATE OR REPLACE FUNCTION calcula_data_fim_proc() RETURNS trigger
AS $$
BEGIN 
	NEW.data_fim = NEW.data_inicio + INTERVAL '1' DAY * NEW.dias_letivos;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calcula_data_fim_trigger BEFORE INSERT OR UPDATE
ON Calendario FOR EACH ROW
EXECUTE PROCEDURE calcula_data_fim_proc ();

-- ATIVIDADE
CREATE TABLE Atividade
(
 	data_inicio date not null,
 	data_fim date,
 	atributo char, -- atributo descriminatório sobre tipo de atividade
 	Calendario_data_inicio date not null,
 	Calendario_tipo char not null default 'a',

 	CONSTRAINT Atividade_Calendario_FK FOREIGN KEY (Calendario_data_inicio, Calendario_tipo) REFERENCES Calendario (data_inicio, tipo),
 	CONSTRAINT Atividade_PK PRIMARY KEY (data_inicio)
);

-- DOCENTE
CREATE TABLE Docente 
(
    Pessoa_rg character varying(9) not null,
    codigo integer not null unique,

    CONSTRAINT Docente_Pessoa_FK FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa(rg),
    CONSTRAINT Docente_PK PRIMARY KEY (Pessoa_rg, codigo)
);

-- ENADE
CREATE TABLE Enade (
	data_realizacao date not null default 'now()',
	nota numeric(2,2),
	Estudante_ra integer,
	Curso_codigo integer,

	CONSTRAINT Enade_Estudante_fk foreign key (Estudante_ra) references Estudante (ra),
	CONSTRAINT Enade_Curso_fk foreign key (Curso_codigo) references Curso (codigo),
	CONSTRAINT Enade_pk primary key (Estudante_ra, Curso_codigo, data_realizacao)
);

-- VISITA
CREATE TABLE Visita 
(
	periodo date not null,
	comite_avaliador character varying(400),
	itens character varying(400),
	ReconhecimentoDeCurso_codigo character varying(10),

	CONSTRAINT Visita_ReconhecimentoDeCurso_fk FOREIGN KEY (ReconhecimentoDeCurso_codigo) REFERENCES ReconhecimentoDeCurso (codigo),
	CONSTRAINT Visita_pk PRIMARY KEY (periodo, ReconhecimentoDeCurso_codigo)
);

-- FASE
CREATE TABLE Fase 
(
	id character varying(10) not null,
	documentos character varying(400),
	periodo date,
	ReconhecimentoDeCurso_codigo character varying(10), 

	CONSTRAINT Fase_ReconhecimentoDeCurso_fk FOREIGN KEY (ReconhecimentoDeCurso_codigo) REFERENCES ReconhecimentoDeCurso (codigo),
	CONSTRAINT Fase_pk PRIMARY KEY (id)
);

-- TÉCNICO ADMINISTRATIVO
CREATE TABLE TecAdm 
(
    Pessoa_rg character varying(9) not null,
    codigo integer not null,

    CONSTRAINT TecAdm_Pessoa_FK FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg), 
    CONSTRAINT TecAdm_PK PRIMARY KEY (Pessoa_rg, codigo)
);

-- PROJETO POLÍTICO-PEDAGÓGICO
CREATE TABLE ProjetoPoliticoPedagogico 
(
	grade gradecurricular,
	Curso_codigo integer,

	CONSTRAINT ProjetoPoliticoPedagogico_Curso_fk FOREIGN KEY (Curso_codigo) REFERENCES Curso (codigo),
	CONSTRAINT ProjetoPoliticoPedagogico_pk PRIMARY KEY (Curso_codigo, grade)
);

-- POLO À DISTANCIA
CREATE TABLE PoloDistancia
(
	nome character varying(12) CONSTRAINT PoloDistancia_PK primary key,
	Estudante_ra integer,
	cep character varying(10),
	rua character varying(40),
	complemento character varying(20),
	bairro character varying(20),
	cidade character varying(20),
	uf character varying(2),
	pais character varying(10),
	pontoGeoreferenciado character varying(50),
	coordenador_PreNome character varying(12),
	coordenador_SobreNome character varying (20),
	coordenador_email1 character varying(20),
	coordenador_email2 character varying(20),
	coordenador_telefone1 character varying(20),
	coordenador_telefone2 character varying(20),
	tutor_PreNome character varying(12),
	tutor_SobreNome character varying(20),
	tutor_email1 character varying(20),
	tutor_email2 character varying(20),
	tutor_telefone1 character varying(20),
	tutor_telefone2 character varying(20),

	CONSTRAINT PoloDistancia_Estudante_fk foreign key (Estudante_ra) references Estudante (RA)
);

-- FOTOS DE UM POLO 
CREATE TABLE PoloDistancia_Foto 
(
	numero integer CONSTRAINT PoloDistancia_Foto_PK primary key,
	PoloDistancia_nome character varying(12),
	imagem character varying(20),

	CONSTRAINT Foto_PoloDistancia_FK foreign key (PoloDistancia_nome) references PoloDistancia (nome)
);

-- TELEFONES DE UM POLO
CREATE TABLE PoloDistancia_Telefone 
(
	tipo character varying(10) CONSTRAINT PoloDistancia_Telefone_PK primary key,
	PoloDistancia_nome character varying(12),
	ddd character varying(3),
	fone character varying(10),
	ramal character varying(5),
	origem character varying(10),
	CONSTRAINT Telefone_PoloDistancia_FK foreign key (PoloDistancia_nome) references PoloDistancia (nome)
);

-- TURMA
CREATE TABLE Turma 
(
 	id char not null unique,
 	vagas integer,
 	ano integer,
 	semestre integer,
 	Disciplina_codigo character varying(10),
 	Docente_codigo integer,

 	CONSTRAINT Turma_Disciplina_fk foreign key (Disciplina_codigo) references Disciplina (codigo),
 	CONSTRAINT Turma_Docente_fk foreign key (Docente_codigo) references Docente (codigo),
 	CONSTRAINT Turma_pk primary key (Disciplina_codigo, id, ano, semestre)
);

-- SALA
CREATE TABLE Sala 
(
 	Turma_id char,
 	Turma_Disciplina_codigo character varying(10),
 	sala character varying(20),

 	CONSTRAINT sala_turma_fk foreign key (Turma_id, Turma_Disciplina_codigo) references Turma (id, Disciplina_codigo),
 	CONSTRAINT sala_pk PRIMARY KEY (Turma_id, Turma_Disciplina_codigo, sala)
);

-- DEPARTAMENTO
CREATE TABLE Departamento
(
  	nome character varying(50),
  	website character varying(100),
  	sigla character varying(10) not null,
  	telefone1 character varying(20) not null,
  	telefone2 character varying(20),
  	endereco character varying (100) not null,
  	Campus_sigla character varying(10),

  	CONSTRAINT Departamento_pk PRIMARY KEY (sigla),
  	CONSTRAINT Departamento_Campus_fk FOREIGN KEY (Campus_sigla) REFERENCES Campus (sigla)
);

-- ENDEREÇO DE PESSOA
CREATE TABLE Pessoa_Endereco
(
    num_casa integer not null,
    Pessoa_rg  character varying(9) not null,
    rua character varying(15),
    complemento character varying(15),
    bairro character varying(15),
    uf character varying(2),
    cep integer,

    CONSTRAINT pessoa_fk FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg),
    CONSTRAINT Pessoa_endereco_pk PRIMARY KEY (Pessoa_rg, num_casa, cep)
);

-- TELEFONE DE PESSOA
CREATE TABLE Pessoa_Telefone
(
    ddd integer not null, 
    numero integer not null,
    tipo character varying(6) not null,
    ramal integer not null,
    Pessoa_rg character varying(9) not null,
    
    CONSTRAINT pessoa_fk FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg),
 	constraint  contato_pk PRIMARY KEY (Pessoa_rg, ddd, numero, ramal, tipo)
);

-- ATA
CREATE TABLE Ata
( 
	documentos character varying(20), 
	ConselhoCurso_id integer not null,
	Reuniao_numero integer not null,
	data_termino date default 'now()',
	

	CONSTRAINT Ata_ConselhoCurso_fk FOREIGN KEY (ConselhoCurso_id) REFERENCES ConselhoCurso (id),
	CONSTRAINT Ata_Reuniao_fk FOREIGN KEY (Reuniao_numero) REFERENCES Reuniao (numero),
	CONSTRAINT Ata_pk PRIMARY KEY(ConselhoCurso_id, Reuniao_numero)
);



---------------------
-- RELACIONAMENTOS --
---------------------

-- Possui (Conselho_Curso x Nucleo_Docente)
CREATE TABLE PossuiCCND
(
	ConselhoCurso_id integer not null,
	NucleoDocente_codigo integer not null,

	CONSTRAINT PossuiCCND_pk PRIMARY KEY (ConselhoCurso_id, NucleoDocente_codigo),
	CONSTRAINT PossuiCCND_ConselhoCurso_fk FOREIGN KEY (ConselhoCurso_id) REFERENCES ConselhoCurso (id),
	CONSTRAINT PossuiCCND_NucleoDocente_fk FOREIGN KEY (NucleoDocente_codigo) REFERENCES NucleoDocente (codigo) 
);

-- Pertence (ConselhoCurso x Pessoa)
CREATE TABLE PertenceCCP 
( 
	categoria character varying(20), 
	periodo date,
	Pessoa_rg character varying(9) not null,
	ConselhoCurso_id integer not null,

	CONSTRAINT PertenceCP_Pessoa_fk FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg),
	CONSTRAINT PertenceCP_ConselhoCurso_fk FOREIGN KEY (ConselhoCurso_id) REFERENCES ConselhoCurso (id),
	CONSTRAINT pertence_PK PRIMARY KEY(Pessoa_rg, ConselhoCurso_id)
);

-- Pertence (Disciplina x Departamento)
CREATE TABLE PertenceDD 
(
	Departamento_sigla character varying(100) not null,
	Disciplina_codigo char not null,

	CONSTRAINT PertenceDD_Departamento_fk foreign key (Departamento_sigla) references Departamento (sigla),
	CONSTRAINT PertenceDD_Disciplina_fk foreign key (Disciplina_codigo) references Disciplina (codigo),
	CONSTRAINT PertenceDD_pk PRIMARY KEY (Departamento_sigla, Disciplina_codigo)
);

-- Pertence (Docente x NucleoDocente)
CREATE TABLE PertenceDND
(
    Docente_Pessoa_rg character varying(9) not null,
    NucleoDocente_codigo integer not null,
    Docente_codigo integer not null,
    periodo date not null, 

    CONSTRAINT PertenceDND_Docente_FK FOREIGN KEY (Docente_Pessoa_rg, Docente_codigo) REFERENCES Docente (Pessoa_rg, codigo),
    CONSTRAINT PertenceDND_NucleoDocente_FK FOREIGN KEY (NucleoDocente_codigo) REFERENCES NucleoDocente (codigo),    
    CONSTRAINT PertenceDND_PK PRIMARY KEY (Docente_Pessoa_rg, Docente_codigo, NucleoDocente_codigo, periodo)
);

-- Possui (Reconhecimento_Curso x Fase)
CREATE TABLE PossuiRCF
(
	periodo date NOT NULL,
	ReconhecimentoDeCurso_codigo character varying(10) not null,
	Fase_id character varying(10) not null,

	CONSTRAINT PossuiRCF_pk PRIMARY KEY (ReconhecimentoDeCurso_codigo, Fase_id),
	CONSTRAINT PossuiRCF_ReconhecimentoDeCurso_fk FOREIGN KEY (ReconhecimentoDeCurso_codigo) REFERENCES ReconhecimentoDeCurso (codigo),
	CONSTRAINT PossuiRCF_Fase_fk FOREIGN KEY (Fase_id) REFERENCES Fase (id) 

);

-- Realiza (AtComp x Estudante)
CREATE TABLE RealizaACE
(
  	Estudante_ra integer not null,
  	AtComp_nome character varying(100) not null,
 
  	CONSTRAINT RealizaACE_pk PRIMARY KEY (Estudante_RA, AtComp_nome),
  	CONSTRAINT RealizaACE_Estudante_fk FOREIGN KEY (Estudante_RA) REFERENCES Estudante (ra),
  	CONSTRAINT RealizaACE_AtComp_fk FOREIGN KEY (AtComp_nome) REFERENCES AtComp (nome)
);

-- Realiza (ConselhoCurso x Reuniao)
CREATE TABLE RealizaCCRe
(
	ConselhoCurso_id integer not null,
	Reuniao_numero integer not null,

	CONSTRAINT RealizaCCRe_ConselhoCurso_fk FOREIGN KEY (ConselhoCurso_id) REFERENCES ConselhoCurso (id),
	CONSTRAINT RealizaCCRe_Reuniao_fk FOREIGN KEY (Reuniao_numero) REFERENCES Reuniao (numero),
	CONSTRAINT RealizaCCRe_pk PRIMARY KEY (ConselhoCurso_id, Reuniao_numero) 
);

-- Compoe (Disciplina x Curso)
CREATE TABLE Compoe
(
	Disciplina_codigo character varying(10) not null,
	Curso_codigo integer not null,
	obrigatoriedade boolean,
	perfil char, -- atributo descriminatório sobre perfil

	CONSTRAINT Compoe_Disciplina_fk FOREIGN KEY (Disciplina_codigo) REFERENCES Disciplina (codigo),
	CONSTRAINT Compoe_Curso_fk FOREIGN KEY (Curso_codigo) REFERENCES Curso (codigo),
	CONSTRAINT Compoe_pk PRIMARY KEY (Disciplina_codigo, Curso_codigo)
);

-- Cursa (Estudante x Turma)
CREATE TABLE Cursa
(
	Estudante_ra integer not null,
	Turma_id char not null,
	semestre integer,
	media numeric(2,2),
	frenquencia numeric(2,2),
	status char,

	CONSTRAINT Cursa_Estudante_fk FOREIGN KEY (Estudante_ra) REFERENCES Estudante (ra),
	CONSTRAINT Cursa_Turma_fk FOREIGN KEY (Turma_id) REFERENCES Turma (id),
	CONSTRAINT Cursa_PK PRIMARY KEY (Estudante_ra,Turma_id) 
);

-- Disciplina Pré-Requisito (Disciplina x Disciplina)
CREATE TABLE DisciplinaPreReq
(
	Disciplina_codigo character varying(10) not null,
	sigla character varying(7),
	nro_creditos integer,
	categoria character varying(20),
	codigoPreRequisito character varying (10) not null,

	CONSTRAINT Disciplina_FK foreign key (Disciplina_codigo) references Disciplina (codigo),
	CONSTRAINT PreReq_FK foreign key (codigoPreRequisito) references Disciplina(codigo),
	CONSTRAINT DisciplinaPreReq_pk primary key (Disciplina_codigo, codigoPreRequisito)
);

-- Efetua (NucleoDocente x Reuniao)
CREATE TABLE Efetua
(
	NucleoDocente_codigo integer not null,
	Reuniao_numero integer not null,

	CONSTRAINT Efetua_NucleoDocente_fk FOREIGN KEY (NucleoDocente_codigo) REFERENCES NucleoDocente (codigo),
	CONSTRAINT Efetua_Reuniao_fk FOREIGN KEY (Reuniao_numero) REFERENCES Reuniao (numero),
	CONSTRAINT Efetua_pk PRIMARY KEY (NucleoDocente_codigo, Reuniao_numero)
);

-- Estagia (Estudante x Empresa)
CREATE TABLE Estagia 
(
    dtInicio date,
    dtTermino date,
    Estudante_cpf character varying(15) not null,
    Empresa_cnpj bigint not null,
    supEmpresa supervisor,
    supUniversidade supervisor,
    cartaAvaliacao text,
    termoCompromisso text,

    constraint Estagia_Empresa_fk FOREIGN KEY (Empresa_cnpj) references Empresa (cnpj),
    constraint Estagia_Estudante_fk FOREIGN KEY (Estudante_cpf) references Estudante (cpf),
    constraint Estagia_pk PRIMARY KEY (Estudante_cpf, Empresa_cnpj)
);

--Inscreve (Estudante x Turma)
CREATE TABLE Inscreve
(
	periodo date,
	deferimento boolean,
	prioridade_inscricao integer,
	Turma_id char not null,
	Estudante_ra integer not null,

	CONSTRAINT Inscreve_pk PRIMARY KEY (Estudante_ra, Turma_id),
	CONSTRAINT Inscreve_Estudante_fk FOREIGN KEY (Estudante_ra) REFERENCES Estudante (ra),
	CONSTRAINT Inscreve_Turma_fk FOREIGN KEY (Turma_id) REFERENCES Turma (id) 

);

-- Matriculado (Estudante x Curso)
CREATE TABLE Matriculado
(
	Estudante_ra integer not null,
	Curso_codigo integer not null,
	grade character varying(15), 
	periodo char, -- atributo descriminatório sobre periodo
	status boolean,
	perfil char, -- atributo descriminatório sobre perfil
	ano_ingresso date,
	ano_termino date,

	CONSTRAINT Matriculado_Estudante_fk FOREIGN KEY (Estudante_ra) REFERENCES Estudante (ra),
	CONSTRAINT Matriculado_Curso_fk FOREIGN KEY (Curso_codigo) REFERENCES Curso (codigo),
	CONSTRAINT Matriculado_pk PRIMARY KEY (Estudante_ra, Curso_codigo)
);
