import 'package:my_wallet/app/models/atividade.dart';

class AtividadeAlunoRealiza {
  final int idAlunoTrilhaRealiza;
  final int idTrilha;
  final int id;
  final Atividade atividade;
  final double acerto;
  final bool feito;
  final int opcaoSelecionada;

  AtividadeAlunoRealiza({
    required this.idAlunoTrilhaRealiza,
    required this.idTrilha,
    required this.id,
    required this.atividade,
    required this.acerto,
    required this.feito,
    required this.opcaoSelecionada,
  });
}
