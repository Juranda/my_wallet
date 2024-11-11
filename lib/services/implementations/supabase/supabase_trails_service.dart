import 'package:my_wallet/models/escolaridade.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/atividade_aluno_realiza.dart';
import 'package:my_wallet/models/trilha/atividade_questao.dart';
import 'package:my_wallet/models/trilha/trail.dart';
import 'package:my_wallet/models/trilha/trilha_aluno_realiza.dart';
import 'package:my_wallet/services/trailsservice.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTrailsService implements TrailsService {
  Future<List<Trilha>> getAllTrilhas(
      int idInstituicaoEnsino, int idTurma) async {
    final maps = await Supabase.instance.client
        .from('turmatrilha_possui')
        .select(
            'trilha(id, nome, img_url, escolaridades(id, nome)), turma(id, escolaridades(id, nome))')
        .eq('turma.id', idTurma);
    final trilhas = <Trilha>[];

    for (var map in maps) {
      int id = map['trilha']['id'];

      map['id'] = id;
      map['nome'] = map['trilha']['nome'];
      map['img_url'] = map['trilha']['img_url'] ?? "";
      map['escolaridade'] = Escolaridade.values
          .elementAt(map['trilha']['escolaridades']['id'] - 1);

      trilhas.add(Trilha.fromMap(map));
    }

    return trilhas;
  }

  Future<List<TrilhaAlunoRealiza>> getAllTrilhasDoAluno(
    int idInstituicao,
    int idAluno, {
    bool cached = false,
  }) async {
    final alunoTrilhas = await Supabase.instance.client
        .from('alunotrilha_realiza')
        .select(
            'id, pontuacao, completada_em, trilha(id, nome, escolaridades(id, nome)), aluno!inner(id, usuario!inner(instituicaoensino(id))), atividadecompleta_aluno!inner(id, acerto, feito, opcao_selecionada, atividade!inner(id, sequencia, enunciado, atividadequestao(sequencia, enunciado, correta), jogos(id)))')
        .eq('aluno.usuario.instituicaoensino.id', idInstituicao)
        .eq('aluno.id', idAluno);

    // await Supabase.instance.client.from('alunotrilha_realiza').select('id, pontuacao, completada_em, trilha()');

    List<TrilhaAlunoRealiza> trilhasAluno = [];

    for (var alunoTrilha in alunoTrilhas) {
      List<AtividadeAlunoRealiza> atividades = [];
      var trilhaMap = alunoTrilha['trilha'];
      var trilha = Trilha(
        trilhaMap['id'],
        trilhaMap['nome'],
        trilhaMap['img_url'] ?? "",
        Escolaridade.values.elementAt(trilhaMap['escolaridades']['id'] - 1),
      );

      for (Map<String, dynamic> atividadeCompletaAluno
          in alunoTrilha['atividadecompleta_aluno']) {
        var respostas = atividadeCompletaAluno['atividade']['atividadequestao']
            as List<dynamic>;

        var atividade = Atividade(
          id: atividadeCompletaAluno['atividade']['id'],
          enunciado: atividadeCompletaAluno['atividade']['enunciado'],
          sequencia: atividadeCompletaAluno['atividade']['sequencia'],
          trilha: trilha,
          respostas: respostas.map((resposta) {
            return AtividadeQuestao(
              sequencia: resposta['sequencia'],
              correta: (resposta['correta'] as bool),
              enunciado: resposta['enunciado'],
            );
          }).toList(),
        );

        atividades.add(AtividadeAlunoRealiza(
          idTrilha: alunoTrilha['trilha']['id'],
          idAlunoTrilhaRealiza: alunoTrilha['id'],
          id: atividadeCompletaAluno['id'],
          acerto: (atividadeCompletaAluno['acerto'] as int).toDouble(),
          opcaoSelecionada: atividadeCompletaAluno['opcao_selecionada'],
          feito: atividadeCompletaAluno['feito'],
          atividade: atividade,
        ));
      }

      trilhasAluno.add(TrilhaAlunoRealiza(
        idInstituicao: idInstituicao,
        trilha: trilha,
        pontuacao: alunoTrilha['pontuacao'],
        idAluno: idAluno,
        completadaEm: alunoTrilha['completada_em'],
        atividades: atividades,
      ));
    }
    return trilhasAluno;
  }
}
