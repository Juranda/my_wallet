class AtividadeOpcao {
  final int sequencia;
  final String enunciado;
  final bool correta;

  AtividadeOpcao({
    required this.sequencia,
    required this.enunciado,
    required this.correta,
  });

  factory AtividadeOpcao.fromMap(Map<String, dynamic> map) {
    return AtividadeOpcao(
        sequencia: map['sequencia'],
        enunciado: map['enunciado'],
        correta: map['correta']);
  }
}
