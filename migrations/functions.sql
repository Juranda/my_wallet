
CREATE OR REPLACE FUNCTION liberar_trilha(turma_id INT, trilha_id INT) RETURNS VOID AS $$
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
$$ LANGUAGE plpgsql;


CREATE FUNCTION ATUALIZAR_DINHEIRO_ALUNO() RETURNS TRIGGER AS $$
BEGIN
    UPDATE Aluno
    SET dinheiro = dinheiro + NEW.valor
    WHERE fk_Usuario_id = NEW.fk_Usuario_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TGR_atualiza_dinheiro AFTER
INSERT ON Transacao -- Executa após a inserção de uma nova transação
FOR EACH ROW EXECUTE FUNCTION atualizar_dinheiro_aluno();


CREATE FUNCTION INSERIR_TRANSACAO (P_VALOR DOUBLE, P_NOME VARCHAR(50), USUARIO_ID INT CATEGORIA_ID INT P_REALIZADA_EM TIMESTAMP) RETURNS VOID AS $$
ALUNO_EXISTE BOOLEAN,
ID_TRANSACAO INTEGER
BEGIN
    SELECT EXISTS (SELECT 1
        FROM Aluno
        WHERE ALUNO.fk_Usuario_id = USUARIO_ID
    ) INTO ALUNO_EXISTE;

    IF NOT (ALUNO_EXISTE)
    BEGIN
        RAISE EXCEPTION 'Aluno nao existe';
    END;

    INSERT INTO TRANSACAO (VALOR, NOME, fk_Usuario_id, FK_CATEGORIA_ID, REALIZADA_EM)
    VALUES (P_VALOR, P_NOME, USUARIO_ID, CATEGORIA_ID, P_REALIZADA_EM)
    RETURNING ID INTO ID_TRANSACAO;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION ON_INSERT_USUARIO() RETURNS trigger AS $$
DECLARE R RECORD;
BEGIN
  FOR R IN 
    select NOME FROM categoria
  LOOP
    INSERT INTO categoria_usuario(NOME, fk_usuario_id) values (R.NOME, NEW.ID);
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_INSERT_USUARIO 
AFTER INSERT ON usuario 
FOR each ROW 
EXECUTE function on_insert_usuario();