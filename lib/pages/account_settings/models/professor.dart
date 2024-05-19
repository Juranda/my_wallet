class Professor {
  final int id;
  final int instituicaoensino;
  final String cpfcnpj;
  final DateTime created_at;
  final String nome;
  final String sobrenome;
  final String id_usuario;

  Professor({
    required this.id,
    required this.instituicaoensino,
    required this.cpfcnpj,
    required this.created_at,
    required this.nome,
    required this.sobrenome,
    required this.id_usuario,
  });
}
