import 'package:my_wallet/models/trilha/atividade_questao.dart';
import 'package:my_wallet/models/trilha/trail.dart';

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
}
