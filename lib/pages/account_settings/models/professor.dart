class Professor {
  final int id;
  final String id_usuario;
  final DateTime created_at;
  final int instituicaoensino;
  final String cpfcnpj;
  final String nome;
  final String sobrenome;
  final String email;
  final String nome_turma;
  final String escolaridade_turma;
  final int id_turma;
  final int id_escolaridade;

  Professor({
    required this.id,
    required this.id_usuario,
    required this.created_at,
    required this.instituicaoensino,
    required this.cpfcnpj,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.nome_turma,
    required this.escolaridade_turma,
    required this.id_turma,
    required this.id_escolaridade,
  });
}
