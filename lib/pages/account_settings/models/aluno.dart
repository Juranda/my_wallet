class Aluno {
  final int id;
  final int instituicaoensino;
  final String cpf;
  final DateTime created_at;
  final String nome;
  final String sobrenome;
  final String escolaridade;
  final String id_usuario;
  final String email;
  final String nome_turma;

  Aluno({
    required this.id,
    required this.instituicaoensino,
    required this.cpf,
    required this.created_at,
    required this.nome,
    required this.sobrenome,
    required this.escolaridade,
    required this.nome_turma,
    required this.id_usuario,
    required this.email,
  });
}
