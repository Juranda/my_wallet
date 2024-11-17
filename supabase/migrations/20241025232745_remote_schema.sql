

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."atualizar_dinheiro_aluno"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    UPDATE Aluno
    SET dinheiro = dinheiro + NEW.valor
    WHERE fk_Usuario_id = NEW.fk_Usuario_id;

    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."atualizar_dinheiro_aluno"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."inserir_transacao"("p_valor" double precision, "p_nome" character varying, "usuario_id" integer, "categoria_id" integer, "p_realizada_em" timestamp without time zone) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
ALUNO_EXISTE BOOLEAN;
BEGIN
    SELECT EXISTS (SELECT 1
        FROM Aluno
        WHERE ALUNO.fk_Usuario_id = USUARIO_ID
    ) INTO ALUNO_EXISTE;

    IF NOT ALUNO_EXISTE THEN
        RAISE EXCEPTION 'Usuário com ID % não encontrado.', USUARIO_ID
            USING ERRCODE = '45000',  -- Código de erro definido pelo usuário
                  DETAIL = 'A consulta não retornou resultados.',
                  HINT = 'Verifique se o ID do usuário está correto';
    END IF;

    INSERT INTO TRANSACAO (VALOR, NOME, fk_Usuario_id, FK_CATEGORIA_ID, REALIZADA_EM)
    VALUES (P_VALOR, P_NOME, USUARIO_ID, CATEGORIA_ID, P_REALIZADA_EM);
END;
$$;


ALTER FUNCTION "public"."inserir_transacao"("p_valor" double precision, "p_nome" character varying, "usuario_id" integer, "categoria_id" integer, "p_realizada_em" timestamp without time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."liberar_trilha"("turma_id" integer, "trilha_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    aluno RECORD;
    atividade RECORD;
    aluno_trilha_id INT;
BEGIN
    -- Passo 1: Inserir o registro na tabela TurmaTrilha_Possui
    INSERT INTO TurmaTrilha_Possui (fk_Turma_id, fk_Trilha_id)
    VALUES (turma_id, trilha_id)
    ON CONFLICT DO NOTHING;  -- Evita inserir duplicados

    -- Passo 2: Para cada aluno da turma, inserir um registro em AlunoTrilha_Realiza
    FOR aluno IN
        SELECT id FROM Aluno WHERE fk_Turma_id = turma_id
    LOOP
        INSERT INTO AlunoTrilha_Realiza (completada_em, pontuacao, fk_Trilha_id, fk_Aluno_id)
        VALUES (NULL, 0, trilha_id, aluno.id)
        RETURNING id INTO aluno_trilha_id;

        -- Passo 3: Para cada atividade da trilha, inserir um registro em AtividadeCompleta_Aluno
        FOR atividade IN
            SELECT id FROM Atividade WHERE fk_Trilha_id = trilha_id
        LOOP
            INSERT INTO AtividadeCompleta_Aluno (feito, acerto, opcao_selecionada, fk_AlunoTrilha_Realiza_id, fk_Trilha_id)
            VALUES (FALSE, 0.0, NULL, aluno_trilha_id, trilha_id);
        END LOOP;
    END LOOP;
END;
$$;


ALTER FUNCTION "public"."liberar_trilha"("turma_id" integer, "trilha_id" integer) OWNER TO "postgres";


COMMENT ON FUNCTION "public"."liberar_trilha"("turma_id" integer, "trilha_id" integer) IS 'Libera a trilha para uma turma específica';



CREATE PROCEDURE "public"."liberar_trilha_completa"(IN "p_fk_turma_id" integer, IN "p_fk_trilha_id" integer)
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    aluno_id INT;
    atividade_id INT;
    v_AlunoTrilha_id INT;
BEGIN
    -- Inserir registro na tabela TurmaTrilha_Possui
    INSERT INTO TurmaTrilha_Possui (fk_Turma_id, fk_Trilha_id)
    VALUES (p_fk_Turma_id, p_fk_Trilha_id);

    -- Para cada aluno da turma
    FOR aluno_id IN
        (SELECT a.id
         FROM Aluno a
         WHERE a.fk_Turma_id = p_fk_Turma_id)
    LOOP
        -- Inserir registro na tabela AlunoTrilha_Realiza para cada aluno
        INSERT INTO AlunoTrilha_Realiza (completada_em, pontuacao, fk_Trilha_id, fk_Aluno_id)
        VALUES (NULL, 0, p_fk_Trilha_id, aluno_id)
        RETURNING id INTO v_AlunoTrilha_id;

        -- Para cada atividade na trilha
        FOR atividade_id IN
            (SELECT a.id
             FROM Atividade a
             WHERE a.fk_Trilha_id = p_fk_Trilha_id)
        LOOP
            -- Inserir registro na tabela AtividadeCompleta_Aluno para cada atividade
            INSERT INTO AtividadeCompleta_Aluno (feito, acerto, opcao_selecionada, fk_AlunoTrilha_Realiza_id, fk_Trilha_id)
            VALUES (FALSE, 0.0, NULL, v_AlunoTrilha_id, p_fk_Trilha_id);
        END LOOP;
    END LOOP;
END;
$$;


ALTER PROCEDURE "public"."liberar_trilha_completa"(IN "p_fk_turma_id" integer, IN "p_fk_trilha_id" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."on_insert_usuario"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE R RECORD;
BEGIN
  FOR R IN 
    select NOME FROM categoria
  LOOP
    INSERT INTO categoria_usuario(NOME, fk_usuario_id) values (R.NOME, NEW.ID);
  END LOOP;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."on_insert_usuario"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."administrador" (
    "id" integer NOT NULL,
    "fk_usuario_id" integer NOT NULL
);


ALTER TABLE "public"."administrador" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."administrador_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."administrador_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."administrador_id_seq" OWNED BY "public"."administrador"."id";



CREATE TABLE IF NOT EXISTS "public"."aluno" (
    "fk_usuario_id" integer NOT NULL,
    "id" integer NOT NULL,
    "cpf" character(11) NOT NULL,
    "dinheiro" double precision NOT NULL,
    "fk_turma_id" integer NOT NULL,
    "fk_escolaridades_id" integer NOT NULL
);


ALTER TABLE "public"."aluno" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."aluno_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."aluno_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."aluno_id_seq" OWNED BY "public"."aluno"."id";



CREATE TABLE IF NOT EXISTS "public"."aluno_trilha_realiza" (
    "id" integer NOT NULL,
    "completada_em" timestamp without time zone,
    "pontuacao" integer NOT NULL,
    "fk_trilha_id" integer NOT NULL,
    "fk_aluno_id" integer NOT NULL
);


ALTER TABLE "public"."aluno_trilha_realiza" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."alunotrilha_realiza_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."alunotrilha_realiza_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."alunotrilha_realiza_id_seq" OWNED BY "public"."aluno_trilha_realiza"."id";



CREATE TABLE IF NOT EXISTS "public"."atividade" (
    "enunciado" character varying(500) NOT NULL,
    "fk_jogos_id" integer,
    "fk_trilha_id" integer NOT NULL,
    "sequencia" integer NOT NULL,
    "id" integer NOT NULL
);


ALTER TABLE "public"."atividade" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."atividade_completa_aluno" (
    "id" integer NOT NULL,
    "feito" boolean NOT NULL,
    "acerto" boolean,
    "opcao_selecionada" integer NOT NULL,
    "fk_alunotrilha_realiza_id" integer NOT NULL,
    "fk_trilha_id" integer NOT NULL,
    "fk_atividade_id" integer,
    "liberada" boolean DEFAULT false
);


ALTER TABLE "public"."atividade_completa_aluno" OWNER TO "postgres";


ALTER TABLE "public"."atividade" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."atividade_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."atividade_questao" (
    "fk_atividade_id" integer NOT NULL,
    "sequencia" integer NOT NULL,
    "enunciado" character varying(500),
    "correta" boolean DEFAULT false
);


ALTER TABLE "public"."atividade_questao" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."atividade_sequencia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."atividade_sequencia_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."atividade_sequencia_seq" OWNED BY "public"."atividade"."sequencia";



CREATE SEQUENCE IF NOT EXISTS "public"."atividadecompleta_aluno_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."atividadecompleta_aluno_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."atividadecompleta_aluno_id_seq" OWNED BY "public"."atividade_completa_aluno"."id";



CREATE TABLE IF NOT EXISTS "public"."categoria" (
    "id" integer NOT NULL,
    "nome" character varying(100)
);


ALTER TABLE "public"."categoria" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."categoria_usuario" (
    "id" integer NOT NULL,
    "nome" "text",
    "fk_usuario_id" integer
);


ALTER TABLE "public"."categoria_usuario" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."categoria_usuario_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."categoria_usuario_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."categoria_usuario_id_seq" OWNED BY "public"."categoria_usuario"."id";



CREATE TABLE IF NOT EXISTS "public"."escolaridades" (
    "nome" character varying(100) NOT NULL,
    "id" integer NOT NULL
);


ALTER TABLE "public"."escolaridades" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."escolaridades_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."escolaridades_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."escolaridades_id_seq" OWNED BY "public"."escolaridades"."id";



CREATE TABLE IF NOT EXISTS "public"."instituicao_ensino" (
    "id" integer NOT NULL,
    "codigo_inep" character(8) NOT NULL,
    "nome" character varying(100) NOT NULL
);


ALTER TABLE "public"."instituicao_ensino" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."instituicao_escolaridade_aplica" (
    "fk_escolaridades_id" integer,
    "fk_instituicaoensino_id" integer
);


ALTER TABLE "public"."instituicao_escolaridade_aplica" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."instituicaoensino_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."instituicaoensino_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."instituicaoensino_id_seq" OWNED BY "public"."instituicao_ensino"."id";



CREATE TABLE IF NOT EXISTS "public"."jogos" (
    "id" integer NOT NULL,
    "nome" character varying(100) NOT NULL
);


ALTER TABLE "public"."jogos" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."jogos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."jogos_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."jogos_id_seq" OWNED BY "public"."jogos"."id";



CREATE TABLE IF NOT EXISTS "public"."noticia_professor" (
    "url" character varying(500) NOT NULL,
    "fk_turma_id" integer NOT NULL,
    "fk_usuario_id" integer NOT NULL
);


ALTER TABLE "public"."noticia_professor" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."professor" (
    "fk_usuario_id" integer NOT NULL,
    "id" integer NOT NULL,
    "cnpjcpf" character varying(14) NOT NULL
);


ALTER TABLE "public"."professor" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."professor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."professor_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."professor_id_seq" OWNED BY "public"."professor"."id";



CREATE TABLE IF NOT EXISTS "public"."tipousuario" (
    "id" integer NOT NULL,
    "tipo" character varying(50) NOT NULL
);


ALTER TABLE "public"."tipousuario" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."tipousuario_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."tipousuario_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."tipousuario_id_seq" OWNED BY "public"."tipousuario"."id";



CREATE TABLE IF NOT EXISTS "public"."transacao" (
    "id" integer NOT NULL,
    "valor" double precision NOT NULL,
    "nome" character varying(100) NOT NULL,
    "realizada_em" timestamp without time zone NOT NULL,
    "fk_usuario_id" integer NOT NULL,
    "fk_categoria_id" integer NOT NULL
);


ALTER TABLE "public"."transacao" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."transacao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."transacao_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."transacao_id_seq" OWNED BY "public"."transacao"."id";



CREATE TABLE IF NOT EXISTS "public"."trilha" (
    "id" integer NOT NULL,
    "nome" character varying(100) NOT NULL,
    "fk_escolaridades_id" integer NOT NULL,
    "img_url" "text"
);


ALTER TABLE "public"."trilha" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."trilha_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."trilha_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."trilha_id_seq" OWNED BY "public"."trilha"."id";



CREATE TABLE IF NOT EXISTS "public"."turma" (
    "id" integer NOT NULL,
    "nome" character varying(100) NOT NULL,
    "fk_instituicaoensino_id" integer NOT NULL,
    "fk_professor_id" integer NOT NULL,
    "fk_escolaridades_id" integer NOT NULL
);


ALTER TABLE "public"."turma" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."turma_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."turma_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."turma_id_seq" OWNED BY "public"."turma"."id";



CREATE TABLE IF NOT EXISTS "public"."turmatrilha_possui" (
    "id" integer NOT NULL,
    "fk_turma_id" integer NOT NULL,
    "fk_trilha_id" integer NOT NULL
);


ALTER TABLE "public"."turmatrilha_possui" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."turmatrilha_possui_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."turmatrilha_possui_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."turmatrilha_possui_id_seq" OWNED BY "public"."turmatrilha_possui"."id";



CREATE TABLE IF NOT EXISTS "public"."usuario" (
    "id" integer NOT NULL,
    "nome" character varying(100) NOT NULL,
    "fk_usuario_supabase" "uuid" NOT NULL,
    "fk_instituicaoensino_id" integer NOT NULL,
    "fk_tipousuario_id" integer NOT NULL,
    "created_at" timestamp without time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."usuario" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."usuario_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."usuario_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."usuario_id_seq" OWNED BY "public"."usuario"."id";



CREATE OR REPLACE VIEW "public"."view_administrador" AS
 SELECT "au"."created_at",
    "u"."fk_usuario_supabase" AS "id_supabase",
    "u"."fk_instituicaoensino_id" AS "id_instituicao_ensino",
    "u"."id" AS "id_usuario",
    "adm"."id",
    "u"."nome",
    "au"."email"
   FROM (("public"."administrador" "adm"
     LEFT JOIN "public"."usuario" "u" ON (("u"."id" = "adm"."fk_usuario_id")))
     LEFT JOIN "auth"."users" "au" ON (("u"."fk_usuario_supabase" = "au"."id")));


ALTER TABLE "public"."view_administrador" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_aluno" AS
 SELECT "au"."created_at",
    "u"."fk_usuario_supabase" AS "id_supabase",
    "u"."fk_instituicaoensino_id" AS "id_instituicao_ensino",
    "u"."id" AS "id_usuario",
    "a"."id",
    "u"."nome",
    "au"."email",
    "a"."cpf",
    "t"."id" AS "id_turma",
    "t"."nome" AS "nome_turma",
    "e"."id" AS "id_escolaridade",
    "e"."nome" AS "escolaridade"
   FROM (((("public"."aluno" "a"
     LEFT JOIN "public"."usuario" "u" ON (("u"."id" = "a"."fk_usuario_id")))
     LEFT JOIN "auth"."users" "au" ON (("u"."fk_usuario_supabase" = "au"."id")))
     LEFT JOIN "public"."turma" "t" ON (("a"."fk_turma_id" = "t"."id")))
     LEFT JOIN "public"."escolaridades" "e" ON (("t"."fk_escolaridades_id" = "e"."id")));


ALTER TABLE "public"."view_aluno" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_gastos" AS
 SELECT "a"."id" AS "id_aluno",
    "t"."id" AS "id_transacao",
    "a"."dinheiro" AS "valor_conta",
    "t"."valor",
    "t"."nome",
    "t"."realizada_em",
    "c"."nome" AS "categoria"
   FROM (("public"."aluno" "a"
     JOIN "public"."transacao" "t" ON (("a"."fk_usuario_id" = "t"."fk_usuario_id")))
     LEFT JOIN "public"."categoria" "c" ON (("c"."id" = "t"."fk_categoria_id")));


ALTER TABLE "public"."view_gastos" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_professor" AS
 SELECT "au"."created_at",
    "u"."fk_usuario_supabase" AS "id_supabase",
    "u"."fk_instituicaoensino_id" AS "id_instituicao_ensino",
    "u"."id" AS "id_usuario",
    "p"."id",
    "u"."nome",
    "au"."email",
    "p"."cnpjcpf"
   FROM (("public"."professor" "p"
     LEFT JOIN "public"."usuario" "u" ON (("u"."id" = "p"."fk_usuario_id")))
     LEFT JOIN "auth"."users" "au" ON (("u"."fk_usuario_supabase" = "au"."id")));


ALTER TABLE "public"."view_professor" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."view_usuario" AS
 SELECT "au"."created_at",
    "u"."fk_usuario_supabase" AS "id_supabase",
    "u"."fk_instituicaoensino_id" AS "id_instituicao_ensino",
    "u"."id" AS "id_usuario",
    "u"."nome",
    "au"."email",
    "tu"."id" AS "id_tipo_usuario",
    "tu"."tipo"
   FROM (("public"."usuario" "u"
     LEFT JOIN "auth"."users" "au" ON (("u"."fk_usuario_supabase" = "au"."id")))
     LEFT JOIN "public"."tipousuario" "tu" ON (("u"."fk_tipousuario_id" = "tu"."id")));


ALTER TABLE "public"."view_usuario" OWNER TO "postgres";


ALTER TABLE ONLY "public"."administrador" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."administrador_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."aluno" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."aluno_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."aluno_trilha_realiza" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."alunotrilha_realiza_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."atividade" ALTER COLUMN "sequencia" SET DEFAULT "nextval"('"public"."atividade_sequencia_seq"'::"regclass");



ALTER TABLE ONLY "public"."atividade_completa_aluno" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."atividadecompleta_aluno_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."categoria_usuario" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."categoria_usuario_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."escolaridades" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."escolaridades_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."instituicao_ensino" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."instituicaoensino_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."jogos" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."jogos_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."professor" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."professor_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."tipousuario" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tipousuario_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."transacao" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."transacao_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."trilha" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."trilha_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."turma" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."turma_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."turmatrilha_possui" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."turmatrilha_possui_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."usuario" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."usuario_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."administrador"
    ADD CONSTRAINT "administrador_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."aluno"
    ADD CONSTRAINT "aluno_cpf_key" UNIQUE ("cpf");



ALTER TABLE ONLY "public"."aluno"
    ADD CONSTRAINT "aluno_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."aluno_trilha_realiza"
    ADD CONSTRAINT "alunotrilha_realiza_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."atividade"
    ADD CONSTRAINT "atividade_id_key" UNIQUE ("id");



ALTER TABLE ONLY "public"."atividade"
    ADD CONSTRAINT "atividade_pkey" PRIMARY KEY ("fk_trilha_id", "sequencia", "id");



ALTER TABLE ONLY "public"."atividade_completa_aluno"
    ADD CONSTRAINT "atividadecompleta_aluno_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."atividade_questao"
    ADD CONSTRAINT "atividadequestao_pkey" PRIMARY KEY ("fk_atividade_id", "sequencia");



ALTER TABLE ONLY "public"."categoria"
    ADD CONSTRAINT "categoria_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categoria_usuario"
    ADD CONSTRAINT "categoria_usuario_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."escolaridades"
    ADD CONSTRAINT "escolaridades_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."instituicao_ensino"
    ADD CONSTRAINT "instituicaoensino_codigo_inep_key" UNIQUE ("codigo_inep");



ALTER TABLE ONLY "public"."instituicao_ensino"
    ADD CONSTRAINT "instituicaoensino_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."jogos"
    ADD CONSTRAINT "jogos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."professor"
    ADD CONSTRAINT "professor_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tipousuario"
    ADD CONSTRAINT "tipousuario_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."transacao"
    ADD CONSTRAINT "transacao_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."trilha"
    ADD CONSTRAINT "trilha_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."turma"
    ADD CONSTRAINT "turma_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."turmatrilha_possui"
    ADD CONSTRAINT "turmatrilha_possui_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."usuario"
    ADD CONSTRAINT "usuario_pkey" PRIMARY KEY ("id");



CREATE OR REPLACE TRIGGER "tg_insert_usuario" AFTER INSERT ON "public"."usuario" FOR EACH ROW EXECUTE FUNCTION "public"."on_insert_usuario"();



CREATE OR REPLACE TRIGGER "tgr_atualiza_dinheiro" AFTER INSERT ON "public"."transacao" FOR EACH ROW EXECUTE FUNCTION "public"."atualizar_dinheiro_aluno"();



ALTER TABLE ONLY "public"."atividade_completa_aluno"
    ADD CONSTRAINT "atividadecompleta_aluno_fk_atividade_id_fkey" FOREIGN KEY ("fk_atividade_id") REFERENCES "public"."atividade"("id") ON UPDATE RESTRICT;



ALTER TABLE ONLY "public"."aluno"
    ADD CONSTRAINT "fk_aluno_1" FOREIGN KEY ("fk_usuario_id") REFERENCES "public"."usuario"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."aluno"
    ADD CONSTRAINT "fk_aluno_2" FOREIGN KEY ("fk_turma_id") REFERENCES "public"."turma"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."aluno"
    ADD CONSTRAINT "fk_aluno_3" FOREIGN KEY ("fk_escolaridades_id") REFERENCES "public"."escolaridades"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."aluno_trilha_realiza"
    ADD CONSTRAINT "fk_alunotrilha_realiza_2" FOREIGN KEY ("fk_trilha_id") REFERENCES "public"."trilha"("id");



ALTER TABLE ONLY "public"."aluno_trilha_realiza"
    ADD CONSTRAINT "fk_alunotrilha_realiza_3" FOREIGN KEY ("fk_aluno_id") REFERENCES "public"."aluno"("id");



ALTER TABLE ONLY "public"."atividade"
    ADD CONSTRAINT "fk_atividade_1" FOREIGN KEY ("fk_trilha_id") REFERENCES "public"."trilha"("id");



ALTER TABLE ONLY "public"."atividade"
    ADD CONSTRAINT "fk_atividade_2" FOREIGN KEY ("fk_jogos_id") REFERENCES "public"."jogos"("id");



ALTER TABLE ONLY "public"."atividade_completa_aluno"
    ADD CONSTRAINT "fk_atividadecompleta_atividade_2" FOREIGN KEY ("fk_alunotrilha_realiza_id") REFERENCES "public"."aluno_trilha_realiza"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."atividade_completa_aluno"
    ADD CONSTRAINT "fk_atividadecompleta_atividade_3" FOREIGN KEY ("fk_trilha_id") REFERENCES "public"."trilha"("id");



ALTER TABLE ONLY "public"."atividade_questao"
    ADD CONSTRAINT "fk_atividadequestao_1" FOREIGN KEY ("fk_atividade_id") REFERENCES "public"."atividade"("id");



ALTER TABLE ONLY "public"."categoria_usuario"
    ADD CONSTRAINT "fk_categoria_aluno_1" FOREIGN KEY ("fk_usuario_id") REFERENCES "public"."usuario"("id");



ALTER TABLE ONLY "public"."instituicao_escolaridade_aplica"
    ADD CONSTRAINT "fk_intituicaoescolaridade_aplica_1" FOREIGN KEY ("fk_escolaridades_id") REFERENCES "public"."escolaridades"("id");



ALTER TABLE ONLY "public"."instituicao_escolaridade_aplica"
    ADD CONSTRAINT "fk_intituicaoescolaridade_aplica_2" FOREIGN KEY ("fk_instituicaoensino_id") REFERENCES "public"."instituicao_ensino"("id");



ALTER TABLE ONLY "public"."noticia_professor"
    ADD CONSTRAINT "fk_noticiaprofessor_1" FOREIGN KEY ("fk_turma_id") REFERENCES "public"."turma"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."noticia_professor"
    ADD CONSTRAINT "fk_noticiaprofessor_2" FOREIGN KEY ("fk_usuario_id") REFERENCES "public"."usuario"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."professor"
    ADD CONSTRAINT "fk_professor_3" FOREIGN KEY ("fk_usuario_id") REFERENCES "public"."usuario"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."transacao"
    ADD CONSTRAINT "fk_transacao_1" FOREIGN KEY ("fk_usuario_id") REFERENCES "public"."usuario"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."transacao"
    ADD CONSTRAINT "fk_transacao_2" FOREIGN KEY ("fk_categoria_id") REFERENCES "public"."categoria"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."trilha"
    ADD CONSTRAINT "fk_trilha_2" FOREIGN KEY ("fk_escolaridades_id") REFERENCES "public"."escolaridades"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."turma"
    ADD CONSTRAINT "fk_turma_2" FOREIGN KEY ("fk_instituicaoensino_id") REFERENCES "public"."instituicao_ensino"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."turma"
    ADD CONSTRAINT "fk_turma_4" FOREIGN KEY ("fk_escolaridades_id") REFERENCES "public"."escolaridades"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."turmatrilha_possui"
    ADD CONSTRAINT "fk_turmatrilha_possui_1" FOREIGN KEY ("fk_turma_id") REFERENCES "public"."turma"("id");



ALTER TABLE ONLY "public"."turmatrilha_possui"
    ADD CONSTRAINT "fk_turmatrilha_possui_2" FOREIGN KEY ("fk_trilha_id") REFERENCES "public"."trilha"("id");



ALTER TABLE ONLY "public"."usuario"
    ADD CONSTRAINT "fk_usuario_1" FOREIGN KEY ("fk_usuario_supabase") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."usuario"
    ADD CONSTRAINT "fk_usuario_2" FOREIGN KEY ("fk_instituicaoensino_id") REFERENCES "public"."instituicao_ensino"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."usuario"
    ADD CONSTRAINT "fk_usuario_3" FOREIGN KEY ("fk_tipousuario_id") REFERENCES "public"."tipousuario"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."administrador"
    ADD CONSTRAINT "fk_usuraio_1" FOREIGN KEY ("fk_usuario_id") REFERENCES "public"."usuario"("id");



ALTER TABLE ONLY "public"."turma"
    ADD CONSTRAINT "turma_fk_professor_id_fkey" FOREIGN KEY ("fk_professor_id") REFERENCES "public"."professor"("id") ON DELETE RESTRICT;



ALTER TABLE "public"."professor" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


CREATE PUBLICATION "transacao_realtime" WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION "transacao_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."transacao";



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";
































































































































































































GRANT ALL ON FUNCTION "public"."atualizar_dinheiro_aluno"() TO "anon";
GRANT ALL ON FUNCTION "public"."atualizar_dinheiro_aluno"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."atualizar_dinheiro_aluno"() TO "service_role";



GRANT ALL ON FUNCTION "public"."inserir_transacao"("p_valor" double precision, "p_nome" character varying, "usuario_id" integer, "categoria_id" integer, "p_realizada_em" timestamp without time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."inserir_transacao"("p_valor" double precision, "p_nome" character varying, "usuario_id" integer, "categoria_id" integer, "p_realizada_em" timestamp without time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."inserir_transacao"("p_valor" double precision, "p_nome" character varying, "usuario_id" integer, "categoria_id" integer, "p_realizada_em" timestamp without time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."liberar_trilha"("turma_id" integer, "trilha_id" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."liberar_trilha"("turma_id" integer, "trilha_id" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."liberar_trilha"("turma_id" integer, "trilha_id" integer) TO "service_role";



GRANT ALL ON PROCEDURE "public"."liberar_trilha_completa"(IN "p_fk_turma_id" integer, IN "p_fk_trilha_id" integer) TO "anon";
GRANT ALL ON PROCEDURE "public"."liberar_trilha_completa"(IN "p_fk_turma_id" integer, IN "p_fk_trilha_id" integer) TO "authenticated";
GRANT ALL ON PROCEDURE "public"."liberar_trilha_completa"(IN "p_fk_turma_id" integer, IN "p_fk_trilha_id" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."on_insert_usuario"() TO "anon";
GRANT ALL ON FUNCTION "public"."on_insert_usuario"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."on_insert_usuario"() TO "service_role";





















GRANT ALL ON TABLE "public"."administrador" TO "anon";
GRANT ALL ON TABLE "public"."administrador" TO "authenticated";
GRANT ALL ON TABLE "public"."administrador" TO "service_role";



GRANT ALL ON SEQUENCE "public"."administrador_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."administrador_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."administrador_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."aluno" TO "anon";
GRANT ALL ON TABLE "public"."aluno" TO "authenticated";
GRANT ALL ON TABLE "public"."aluno" TO "service_role";



GRANT ALL ON SEQUENCE "public"."aluno_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."aluno_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."aluno_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."aluno_trilha_realiza" TO "anon";
GRANT ALL ON TABLE "public"."aluno_trilha_realiza" TO "authenticated";
GRANT ALL ON TABLE "public"."aluno_trilha_realiza" TO "service_role";



GRANT ALL ON SEQUENCE "public"."alunotrilha_realiza_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."alunotrilha_realiza_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."alunotrilha_realiza_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."atividade" TO "anon";
GRANT ALL ON TABLE "public"."atividade" TO "authenticated";
GRANT ALL ON TABLE "public"."atividade" TO "service_role";



GRANT ALL ON TABLE "public"."atividade_completa_aluno" TO "anon";
GRANT ALL ON TABLE "public"."atividade_completa_aluno" TO "authenticated";
GRANT ALL ON TABLE "public"."atividade_completa_aluno" TO "service_role";



GRANT ALL ON SEQUENCE "public"."atividade_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."atividade_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."atividade_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."atividade_questao" TO "anon";
GRANT ALL ON TABLE "public"."atividade_questao" TO "authenticated";
GRANT ALL ON TABLE "public"."atividade_questao" TO "service_role";



GRANT ALL ON SEQUENCE "public"."atividade_sequencia_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."atividade_sequencia_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."atividade_sequencia_seq" TO "service_role";



GRANT ALL ON SEQUENCE "public"."atividadecompleta_aluno_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."atividadecompleta_aluno_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."atividadecompleta_aluno_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."categoria" TO "anon";
GRANT ALL ON TABLE "public"."categoria" TO "authenticated";
GRANT ALL ON TABLE "public"."categoria" TO "service_role";



GRANT ALL ON TABLE "public"."categoria_usuario" TO "anon";
GRANT ALL ON TABLE "public"."categoria_usuario" TO "authenticated";
GRANT ALL ON TABLE "public"."categoria_usuario" TO "service_role";



GRANT ALL ON SEQUENCE "public"."categoria_usuario_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."categoria_usuario_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."categoria_usuario_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."escolaridades" TO "anon";
GRANT ALL ON TABLE "public"."escolaridades" TO "authenticated";
GRANT ALL ON TABLE "public"."escolaridades" TO "service_role";



GRANT ALL ON SEQUENCE "public"."escolaridades_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."escolaridades_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."escolaridades_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."instituicao_ensino" TO "anon";
GRANT ALL ON TABLE "public"."instituicao_ensino" TO "authenticated";
GRANT ALL ON TABLE "public"."instituicao_ensino" TO "service_role";



GRANT ALL ON TABLE "public"."instituicao_escolaridade_aplica" TO "anon";
GRANT ALL ON TABLE "public"."instituicao_escolaridade_aplica" TO "authenticated";
GRANT ALL ON TABLE "public"."instituicao_escolaridade_aplica" TO "service_role";



GRANT ALL ON SEQUENCE "public"."instituicaoensino_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."instituicaoensino_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."instituicaoensino_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."jogos" TO "anon";
GRANT ALL ON TABLE "public"."jogos" TO "authenticated";
GRANT ALL ON TABLE "public"."jogos" TO "service_role";



GRANT ALL ON SEQUENCE "public"."jogos_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."jogos_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."jogos_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."noticia_professor" TO "anon";
GRANT ALL ON TABLE "public"."noticia_professor" TO "authenticated";
GRANT ALL ON TABLE "public"."noticia_professor" TO "service_role";



GRANT ALL ON TABLE "public"."professor" TO "anon";
GRANT ALL ON TABLE "public"."professor" TO "authenticated";
GRANT ALL ON TABLE "public"."professor" TO "service_role";



GRANT ALL ON SEQUENCE "public"."professor_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."professor_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."professor_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tipousuario" TO "anon";
GRANT ALL ON TABLE "public"."tipousuario" TO "authenticated";
GRANT ALL ON TABLE "public"."tipousuario" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tipousuario_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tipousuario_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tipousuario_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."transacao" TO "anon";
GRANT ALL ON TABLE "public"."transacao" TO "authenticated";
GRANT ALL ON TABLE "public"."transacao" TO "service_role";



GRANT ALL ON SEQUENCE "public"."transacao_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."transacao_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."transacao_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."trilha" TO "anon";
GRANT ALL ON TABLE "public"."trilha" TO "authenticated";
GRANT ALL ON TABLE "public"."trilha" TO "service_role";



GRANT ALL ON SEQUENCE "public"."trilha_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."trilha_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."trilha_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."turma" TO "anon";
GRANT ALL ON TABLE "public"."turma" TO "authenticated";
GRANT ALL ON TABLE "public"."turma" TO "service_role";



GRANT ALL ON SEQUENCE "public"."turma_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."turma_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."turma_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."turmatrilha_possui" TO "anon";
GRANT ALL ON TABLE "public"."turmatrilha_possui" TO "authenticated";
GRANT ALL ON TABLE "public"."turmatrilha_possui" TO "service_role";



GRANT ALL ON SEQUENCE "public"."turmatrilha_possui_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."turmatrilha_possui_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."turmatrilha_possui_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."usuario" TO "anon";
GRANT ALL ON TABLE "public"."usuario" TO "authenticated";
GRANT ALL ON TABLE "public"."usuario" TO "service_role";



GRANT ALL ON SEQUENCE "public"."usuario_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."usuario_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."usuario_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."view_administrador" TO "anon";
GRANT ALL ON TABLE "public"."view_administrador" TO "authenticated";
GRANT ALL ON TABLE "public"."view_administrador" TO "service_role";



GRANT ALL ON TABLE "public"."view_aluno" TO "anon";
GRANT ALL ON TABLE "public"."view_aluno" TO "authenticated";
GRANT ALL ON TABLE "public"."view_aluno" TO "service_role";



GRANT ALL ON TABLE "public"."view_gastos" TO "anon";
GRANT ALL ON TABLE "public"."view_gastos" TO "authenticated";
GRANT ALL ON TABLE "public"."view_gastos" TO "service_role";



GRANT ALL ON TABLE "public"."view_professor" TO "anon";
GRANT ALL ON TABLE "public"."view_professor" TO "authenticated";
GRANT ALL ON TABLE "public"."view_professor" TO "service_role";



GRANT ALL ON TABLE "public"."view_usuario" TO "anon";
GRANT ALL ON TABLE "public"."view_usuario" TO "authenticated";
GRANT ALL ON TABLE "public"."view_usuario" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
