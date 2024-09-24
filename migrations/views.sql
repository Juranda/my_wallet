/* VIEW USUARIO */
CREATE VIEW VIEW_USUARIO AS
SELECT au.created_at,
       u.fk_usuario_supabase as "id_supabase",
       u.fk_instituicaoensino_id as "id_instituicao_ensino",
       u.id as "id_usuario",
       u.nome,
       au.email,
       tu.id as "id_tipo_usuario",
       tu.tipo
FROM usuario u
left join auth.users au on u.fk_usuario_supabase = au.id
left join tipousuario tu on u.fk_tipousuario_id = tu.id;

/* VIEW ALUNO */
create view view_aluno as
SELECT au.created_at,
       u.fk_usuario_supabase as "id_supabase",
       u.fk_instituicaoensino_id as "id_instituicao_ensino",
       u.id as "id_usuario",
       a.id,
       u.nome,
       au.email,
       a.cpf,
       t.id as "id_turma",
       t.nome as "nome_turma",
       e.id as "id_escolaridade",
       e.nome as "escolaridade"
FROM aluno a
left join usuario U on U.id = a.fk_usuario_id
left join auth.users au on u.fk_usuario_supabase = au.id
left join turma t on a.fk_turma_id = t.id
left join escolaridades e on t.fk_escolaridades_id = e.id;

/* VIEW PROFESSOR */
CREATE view view_professor as
SELECT au.created_at,
       u.fk_usuario_supabase as "id_supabase",
       u.fk_instituicaoensino_id as "id_instituicao_ensino",
       u.id as "id_usuario",
       p.id,
       u.nome,
       au.email,
       p.cnpjcpf
FROM professor p
left join usuario U on U.id = p.fk_usuario_id
left join auth.users au on u.fk_usuario_supabase = au.id;

/* VIEW ADMINISTRADOR */
CREATE VIEW view_administrador as
SELECT au.created_at,
       u.fk_usuario_supabase as "id_supabase",
       u.fk_instituicaoensino_id as "id_instituicao_ensino",
       u.id as "id_usuario",
       adm.id,
       u.nome,
       au.email
FROM administrador adm
left join usuario U on U.id = adm.fk_usuario_id
left join auth.users au on u.fk_usuario_supabase = au.id;

/* VIEW GASTOS  */
create view view_gastos as
select
  a.id as "id_aluno",
  t.id as "id_transacao",
  a.dinheiro as "valor_conta",
  t.valor,
  t.nome,
  realizada_em,
  c.nome as "categoria"
from
  aluno a
  inner join transacao t on a.fk_usuario_id = t.fk_usuario_id
  left join categoria c on c.id = t.fk_categoria_id;