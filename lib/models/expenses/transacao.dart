class Transacao {
  final int id;
  final int idAluno;
  final String nome;
  final double valor;
  final String categoria;
  final DateTime realizadaEm;

  Transacao({
    required this.id,
    required this.idAluno,
    required this.nome,
    required this.valor,
    required this.realizadaEm,
    required this.categoria,
  });
}
