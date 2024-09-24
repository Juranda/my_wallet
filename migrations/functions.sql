
CREATE OR REPLACE FUNCTION liberar_trilha(turma_id INT, trilha_id INT)
RETURNS VOID AS $$
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
