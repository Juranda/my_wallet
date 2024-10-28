import 'package:my_wallet/models/trilha/atividade_questao.dart';
import 'package:my_wallet/models/trilha/trilha.dart';

class Atividade {
  final Trilha trilha;
  final int id;
  final int sequencia;
  final String enunciado;

  final List<AtividadeQuestao> respostas;

  Atividade({
    required this.trilha,
    required this.id,
    required this.sequencia,
    required this.enunciado,
    required this.respostas,
  });

  factory Atividade.fromMap(Map<String, dynamic> map) {
    return Atividade(
      trilha: Trilha.fromMap(map['trilha']),
      id: map['id'],
      sequencia: map['sequencia'],
      enunciado: map['enunciado'],
      respostas: map['respostas']
    );
  }
}
