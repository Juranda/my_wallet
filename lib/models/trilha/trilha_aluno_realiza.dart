import 'package:my_wallet/models/trilha/atividade_aluno_realiza.dart';
import 'package:my_wallet/models/trilha/trilha.dart';

class TrilhaAlunoRealiza {
  final int id;
  final int id_aluno;
  final int pontuacao;
  final DateTime? completada_em;
  final Trilha trilha;
  final List<AtividadeAlunoRealiza> atividades;

  TrilhaAlunoRealiza({
    required this.id,
    required this.trilha,
    required this.id_aluno,
    required this.pontuacao,
    required this.completada_em,
    required this.atividades,
  });

  factory TrilhaAlunoRealiza.fromMap(Map<String, dynamic> map){
    return TrilhaAlunoRealiza(
      id: map['id'], 
      id_aluno: map['fk_aluno_id'], 
      pontuacao: map['pontuacao'], 
      completada_em: map['completada_em'], 
      trilha: map['trilha'], 
      atividades: map['atividades']);
  }
}
