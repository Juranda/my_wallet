import 'package:my_wallet/app/models/atividade_aluno_realiza.dart';
import 'package:my_wallet/app/models/trail.dart';

class TrilhaAlunoRealiza {
  final int idInstituicao;
  final int idAluno;
  final int pontuacao;
  final DateTime? completadaEm;
  final Trilha trilha;
  final List<AtividadeAlunoRealiza> atividades;

  TrilhaAlunoRealiza({
    required this.idInstituicao,
    required this.trilha,
    required this.idAluno,
    required this.pontuacao,
    required this.completadaEm,
    required this.atividades,
  });
}
