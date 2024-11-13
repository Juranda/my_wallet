import 'package:my_wallet/models/trilha/atividade.dart';

class AlunoAtividadeRealiza {
  final int id;
  final int idTrilha;
  final int idAlunoTrilhaRealiza;
  final Atividade atividade;
  final bool? acerto;
  bool feito;
  int opcaoSelecionada;

  AlunoAtividadeRealiza({
    required this.id,
    required this.idTrilha,
    required this.idAlunoTrilhaRealiza,
    required this.atividade,
    required this.acerto,
    required this.feito,
    required this.opcaoSelecionada,
  });

  factory AlunoAtividadeRealiza.fromMap(Map<String, dynamic> map){
    return AlunoAtividadeRealiza(
      id: map['id'], 
      idTrilha: map['fk_trilha_id'], 
      idAlunoTrilhaRealiza: map['fk_alunotrilha_realiza_id'], 
      atividade: Atividade.fromMap(map['atividade']), 
      acerto: map['acerto'], 
      feito: map['feito'], 
      opcaoSelecionada: map['opcao_selecionada']);
  }
}
