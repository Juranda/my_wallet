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

  factory AlunoTrilhaRealiza.fromMap(Map<String, dynamic> map) {
    List<AlunoAtividadeRealiza> atividades = [];
    (map['alunoAtividade_realiza'] as List<dynamic>).sort((a, b) =>
        (a['atividade']['sequencia'] as int)
            .compareTo(b['atividade']['sequencia'] as int));

    for (var atividade in map['alunoAtividade_realiza']) {
      atividades.add(AlunoAtividadeRealiza.fromMap(atividade));
    }
    return AlunoTrilhaRealiza(
      id: map['id'],
      idAluno: map['aluno']['id'],
      pontuacao: map['pontuacao'] ?? 0,
      completadaEm: map['completada_em'] == null
          ? null
          : DateTime.parse(map['completada_em']),
      trilha: Trilha.fromMap(map['trilha']),
      atividades: atividades,
    );
  }
}
