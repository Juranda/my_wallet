/* SCHEMA DO BANCO COM DADOS INICIAIS */

CREATE TABLE Trilha (
    id SERIAL PRIMARY KEY,
    nome varchar(100) not null,
    fk_Escolaridades_id int not null
);

CREATE TABLE Atividade (
    id serial,
    enunciado varchar(500) not null,
    fk_Jogos_id int,
    fk_Trilha_id int,
    sequencia SERIAL,
    PRIMARY KEY (id, sequencia)
);

CREATE TABLE AtividadeQuestao (
    fk_Atividade_id int,
    sequencia int not null,
    enunciado varchar(500),
    correta BOOLEAN,
    PRIMARY KEY (fk_Atividade_id, sequencia)
);

ALTER TABLE AtividadeQuestao ADD CONSTRAINT Fk_AtividadeQuestao_1 
 FOREIGN KEY (fk_Atividade_id) REFERENCES Atividade (id);

CREATE TABLE Jogos (
    id SERIAL PRIMARY KEY,
    nome varchar(100) not null
);

CREATE TABLE Turma (
    id SERIAL PRIMARY KEY,
    nome varchar(100) NOT NULL,
    fk_InstituicaoEnsino_id int not null,
    fk_Professor_id int not null,
    fk_Escolaridades_id int not null
);

CREATE TABLE TurmaTrilha_Possui (
    fk_Turma_id int not null,
    fk_Trilha_id int not null
);

CREATE TABLE AlunoTrilha_Realiza (
    id SERIAL PRIMARY KEY,
    completada_em timestamp,
    pontuacao int NOT NULL,
    fk_Trilha_id int not null,
    fk_Aluno_id int not null
);

CREATE TABLE AtividadeCompleta_Aluno (
    id SERIAL PRIMARY KEY,
    feito bool NOT NULL,
    acerto float not null,
    opcao_selecionada int,
    fk_AlunoTrilha_Realiza_id int not null,
    fk_Trilha_id int not null
);

CREATE TABLE NoticiaProfessor (
    url varchar(500) NOT NULL,
    fk_Turma_id int not null,
    fk_Usuario_id int not null
);

CREATE TABLE Usuario (
    id SERIAL PRIMARY KEY,
    nome varchar(100) NOT NULL,
    fk_Usuario_supabase uuid NOT NULL,
    fk_InstituicaoEnsino_id int not null,
    fk_TipoUsuario_id int not null
);

CREATE TABLE Aluno (
    fk_Usuario_id int not null,
    id serial PRIMARY key not null,
    cpf char(11) not null,
    dinheiro money not null,
    fk_Turma_id int not null,
    fk_Escolaridades_id int not null
);

CREATE TABLE Professor (
    fk_Usuario_id int not null,
    id serial PRIMARY key not null,
    cnpjcpf VARCHAR(14) not null
);

CREATE TABLE ADMINISTRADOR (
    id serial PRIMARY KEY not null,
    FK_Usuario_id int not null
);

alter table ADMINISTRADOR add CONSTRAINT fk_Usuraio_1
FOREIGN key (fk_usuario_id) REFERENCES Usuario (id);

CREATE TABLE Escolaridades (
    nome varchar(100) NOT NULL,
    id SERIAL PRIMARY KEY
);

CREATE TABLE InstituicaoEnsino (
    id SERIAL PRIMARY KEY,
    codigo_inep char(8) NOT NULL,
    nome varchar(100) NOT NULL
);

CREATE TABLE InstituicaoEscolaridade_Aplica (
    fk_Escolaridades_id int,
    fk_InstituicaoEnsino_id int
);

CREATE TABLE TipoUsuario (
    id SERIAL PRIMARY KEY,
    tipo VARchar(50) NOT NULL
);

CREATE TABLE Transacao (
    id serial PRIMARY KEY,
    valor money,
    nome varchar(100),
    fk_Usuario_id int,
    fk_Categoria_id int
);

CREATE TABLE Categoria (
    id int PRIMARY KEY,
    nome varchar(100)
);
 
ALTER TABLE Trilha ADD CONSTRAINT FK_Trilha_2
    FOREIGN KEY (fk_Escolaridades_id)
    REFERENCES Escolaridades (id)
    ON DELETE RESTRICT;

ALTER TABLE Atividade ADD CONSTRAINT Fk_Atividade_1
    FOREIGN KEY (fk_Trilha_id)
    REFERENCES Trilha (id);

ALTER TABLE Atividade ADD CONSTRAINT Fk_Atividade_2
    FOREIGN KEY (fk_Jogos_id)
    REFERENCES Jogos (id);

ALTER TABLE Turma ADD CONSTRAINT FK_Turma_2
    FOREIGN KEY (fk_InstituicaoEnsino_id)
    REFERENCES InstituicaoEnsino (id)
    ON DELETE RESTRICT;
 
ALTER TABLE Turma ADD CONSTRAINT FK_Turma_3
    FOREIGN KEY (fk_Professor_id)
    REFERENCES Professor (id)
    ON DELETE CASCADE;
 
ALTER TABLE Turma ADD CONSTRAINT FK_Turma_4
    FOREIGN KEY (fk_Escolaridades_id)
    REFERENCES Escolaridades (id)
    ON DELETE CASCADE;
 
ALTER TABLE TurmaTrilha_Possui ADD CONSTRAINT FK_TurmaTrilha_Possui_1
    FOREIGN KEY (fk_Turma_id)
    REFERENCES Turma (id);
 
ALTER TABLE TurmaTrilha_Possui ADD CONSTRAINT FK_TurmaTrilha_Possui_2
    FOREIGN KEY (fk_Trilha_id)
    REFERENCES Trilha (id);
 
ALTER TABLE AlunoTrilha_Realiza ADD CONSTRAINT FK_AlunoTrilha_Realiza_2
    FOREIGN KEY (fk_Trilha_id)
    REFERENCES Trilha (id);
 
ALTER TABLE AlunoTrilha_Realiza ADD CONSTRAINT FK_AlunoTrilha_Realiza_3
    FOREIGN KEY (fk_Aluno_id)
    REFERENCES Aluno (id);
 
ALTER TABLE AtividadeCompleta_Aluno ADD CONSTRAINT FK_AtividadeCompleta_Atividade_2
    FOREIGN KEY (fk_AlunoTrilha_Realiza_id)
    REFERENCES AlunoTrilha_Realiza (id)
    ON DELETE RESTRICT;
 
ALTER TABLE AtividadeCompleta_Aluno ADD CONSTRAINT FK_AtividadeCompleta_Atividade_3
    FOREIGN KEY (fk_Trilha_id)
    REFERENCES Trilha (id);
 
ALTER TABLE NoticiaProfessor ADD CONSTRAINT FK_NoticiaProfessor_1
    FOREIGN KEY (fk_Turma_id)
    REFERENCES Turma (id)
    ON DELETE CASCADE;
 
ALTER TABLE NoticiaProfessor ADD CONSTRAINT FK_NoticiaProfessor_2
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE CASCADE;
 
ALTER TABLE Usuario ADD CONSTRAINT FK_Usuario_1
    FOREIGN KEY (fk_Usuario_supabase)
    REFERENCES auth.users (id)
    ON DELETE CASCADE;

ALTER TABLE Usuario ADD CONSTRAINT FK_Usuario_2
    FOREIGN KEY (fk_InstituicaoEnsino_id)
    REFERENCES InstituicaoEnsino (id)
    ON DELETE RESTRICT;

ALTER TABLE Usuario ADD CONSTRAINT FK_Usuario_3
    FOREIGN KEY (fk_TipoUsuario_id)
    REFERENCES TipoUsuario (id)
    ON DELETE CASCADE;

ALTER TABLE Aluno ADD CONSTRAINT FK_Aluno_1
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE RESTRICT;

ALTER TABLE Aluno ADD CONSTRAINT FK_Aluno_2
    FOREIGN KEY (fk_Turma_id)
    REFERENCES Turma (id)
    ON DELETE RESTRICT;

ALTER TABLE Aluno ADD CONSTRAINT FK_Aluno_3
    FOREIGN KEY (fk_Escolaridades_id)
    REFERENCES Escolaridades (id)
    ON DELETE CASCADE;
 
ALTER TABLE Professor ADD CONSTRAINT FK_Professor_3
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE CASCADE;

ALTER TABLE InstituicaoEscolaridade_Aplica ADD CONSTRAINT FK_IntituicaoEscolaridade_Aplica_1
    FOREIGN KEY (fk_Escolaridades_id)
    REFERENCES Escolaridades (id);
 
ALTER TABLE InstituicaoEscolaridade_Aplica ADD CONSTRAINT FK_IntituicaoEscolaridade_Aplica_2
    FOREIGN KEY (fk_InstituicaoEnsino_id)
    REFERENCES InstituicaoEnsino (id);
 
ALTER TABLE Transacao ADD CONSTRAINT FK_Transacao_1
    FOREIGN KEY (fk_Usuario_id)
    REFERENCES Usuario (id)
    ON DELETE RESTRICT;

/* VALORES PADRÕES */
INSERT INTO TipoUsuario (ID, tipo) VALUES (1, 'PROFESSOR'), (2, 'ALUNO'), (3, 'ADMINISTRADOR');
INSERT INTO InstituicaoEnsino (ID, NOME, codigo_inep) VALUES (1, 'INSTITUICAO PADRAO', '00000000');
INSERT INTO Escolaridades (ID, NOME) VALUES (1, 'ENSINO FUNDAMENTAL'), (2, 'ENSINO MÉDIO'), (3, 'ENSINO SUPERIOR');
INSERT INTO InstituicaoEscolaridade_Aplica (fk_Escolaridades_id, fk_InstituicaoEnsino_id) values (1, 1), (2, 1), (3, 1);
INSERT INTO Categoria (ID, NOME) VALUES (1, 'ESSENCIAL'), (2, 'NÃO NECESSARIO');