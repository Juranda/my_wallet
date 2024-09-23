import 'package:my_wallet/app/models/atividade_questao.dart';
import 'package:my_wallet/app/models/trail.dart';

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
