import 'package:my_wallet/models/trilha/atividade.dart';

class AlunoAtividadeRealiza {
  final int id;
  final int idTrilha;
  final int idAlunoTrilhaRealiza;
  final Atividade atividade;
  final bool? acerto;
  final bool feito;
  final int opcaoSelecionada;

  AlunoAtividadeRealiza({
    required this.id,
    required this.idTrilha,
    required this.idAlunoTrilhaRealiza,
    required this.atividade,
    required this.acerto,
    required this.feito,
    required this.opcaoSelecionada,
  });
}
