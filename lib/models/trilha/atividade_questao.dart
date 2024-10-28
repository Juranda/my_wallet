class AtividadeQuestao {
  final int sequencia;
  final String enunciado;
  final bool correta;

  AtividadeQuestao({
    required this.sequencia,
    required this.enunciado,
    required this.correta,
  });

  factory AtividadeQuestao.fromMap(Map<String, dynamic> map){
    return AtividadeQuestao(
      sequencia: map['sequencia'], 
      enunciado: map['enunciado'], 
      correta: map['correta']);
  }
}
