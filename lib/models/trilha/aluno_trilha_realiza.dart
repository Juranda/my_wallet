import 'package:my_wallet/models/trilha/aluno_atividade_realiza.dart';
import 'package:my_wallet/models/trilha/trilha.dart';

class AlunoTrilhaRealiza {
  final int id;
  final int idAluno;
  final int pontuacao;
  final DateTime? completadaEm;
  final Trilha trilha;
  final List<AlunoAtividadeRealiza> atividades;

  AlunoTrilhaRealiza({
    required this.id,
    required this.trilha,
    required this.idAluno,
    required this.pontuacao,
    required this.completadaEm,
    required this.atividades,
  });

  factory AlunoTrilhaRealiza.fromMap(Map<String, dynamic> map){
    return AlunoTrilhaRealiza(
      id: map['id'], 
      idAluno: map['fk_aluno_id'], 
      pontuacao: map['pontuacao'], 
      completadaEm: map['completada_em'], 
      trilha: map['trilha'], 
      atividades: map['atividades']);
  }
}
