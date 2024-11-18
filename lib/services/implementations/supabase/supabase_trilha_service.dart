import 'package:my_wallet/models/escolaridade.dart';
import 'package:my_wallet/models/trilha/aluno_atividade_realiza.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/atividade_opcao.dart';
import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/services/trilha_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTrilhaService implements TrilhaService {
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

  Future<List<AlunoTrilhaRealiza>> getAllAlunoTrilhaRealiza(
      int trilhaId, int turmaId) async {
    var alunos = await Supabase.instance.client
        .from('aluno')
        .select()
        .eq('fk_turma_id', turmaId);
    List<AlunoTrilhaRealiza> alunoTrilhaRealiza = [];

    for (var aluno in alunos) {
      var response = await Supabase.instance.client
          .from('alunoTrilha_realiza')
          .select(
              '*,trilha(*),alunoAtividade_realiza(*,atividade(*,trilha(*),atividadeOpcao(*)))')
          .eq('fk_aluno_id', aluno['id'])
          .eq('fk_trilha_id', trilhaId);

      if (response.isNotEmpty)
        alunoTrilhaRealiza.add(AlunoTrilhaRealiza.fromMap(response[0]));
    }
    return alunoTrilhaRealiza;
  }

  Future<List<AlunoTrilhaRealiza>> getAllTrilhasDoAluno(
    int idInstituicao,
    int idAluno, {
    bool cached = false,
  }) async {
    final alunoTrilhas = await Supabase.instance.client
        .from('alunoTrilha_realiza')
        .select(
            'id, pontuacao, completada_em, trilha(id, nome, escolaridades(id, nome)), aluno!inner(id, usuario!inner(instituicaoensino(id))), alunoAtividade_realiza!inner(id, acerto, feito, opcao_selecionada, atividade!inner(id, sequencia, enunciado, atividadeOpcao(sequencia, enunciado, correta), jogos(id)))')
        .eq('aluno.usuario.instituicaoensino.id', idInstituicao)
        .eq('aluno.id', idAluno);

    // await Supabase.instance.client.from('alunotrilha_realiza').select('id, pontuacao, completada_em, trilha()');

    List<AlunoTrilhaRealiza> trilhasAluno = [];

    for (var alunoTrilha in alunoTrilhas) {
      List<AlunoAtividadeRealiza> atividades = [];
      var trilhaMap = alunoTrilha['trilha'];
      var trilha = Trilha.fromMap(trilhaMap);

      // (
      //   id: trilhaMap['id'],
      //   nome: trilhaMap['nome'],
      //   imgUrl: trilhaMap['img_url'] ?? "",
      //   escolaridade:
      //       Escolaridade.values.elementAt(trilhaMap['escolaridades']['id'] - 1),
      // );

      for (Map<String, dynamic> atividadeCompletaAluno
          in alunoTrilha['alunoAtividade_realiza']) {
        var respostas = atividadeCompletaAluno['atividade']['atividadeOpcao']
            as List<dynamic>;

        var atividade = Atividade(
          id: atividadeCompletaAluno['atividade']['id'],
          enunciado: atividadeCompletaAluno['atividade']['enunciado'],
          sequencia: atividadeCompletaAluno['atividade']['sequencia'],
          trilha: trilha,
          respostas: respostas.map((resposta) {
            return AtividadeOpcao(
              sequencia: resposta['sequencia'],
              correta: (resposta['correta'] as bool),
              enunciado: resposta['enunciado'],
            );
          }).toList(),
        );

        atividades.add(AlunoAtividadeRealiza(
          idTrilha: alunoTrilha['trilha']['id'],
          idAlunoTrilhaRealiza: alunoTrilha['id'],
          id: atividadeCompletaAluno['id'],
          acerto: atividadeCompletaAluno['acerto'],
          opcaoSelecionada: atividadeCompletaAluno['opcao_selecionada'],
          feito: atividadeCompletaAluno['feito'],
          atividade: atividade,
        ));
      }

      trilhasAluno.add(AlunoTrilhaRealiza(
        id: alunoTrilha['id'],
        trilha: trilha,
        pontuacao: alunoTrilha['pontuacao'] ?? 0,
        idAluno: idAluno,
        completadaEm: alunoTrilha['completada_em'] == null
            ? null
            : DateTime.parse(alunoTrilha['completada_em']),
        atividades: atividades,
      ));
    }
    return trilhasAluno;
  }

  Future<AlunoTrilhaRealiza> finalizarTrilha(
      AlunoTrilhaRealiza alunoTrilha_realiza) async {
    for (var atividade in alunoTrilha_realiza.atividades) {
      await Supabase.instance.client.from('alunoAtividade_realiza').update({
        'opcao_selecionada': atividade.opcaoSelecionada,
        'feito': true
      }).eq('id', atividade.id);
    }

    await Supabase.instance.client
        .from('alunoTrilha_realiza')
        .update({'completada_em': DateTime.now().toIso8601String()}).eq(
            'id', alunoTrilha_realiza.id);

    var response = await Supabase.instance.client
        .from('alunoTrilha_realiza')
        .select(
            'id, pontuacao, completada_em, trilha(id, nome, escolaridades(id), img_url), aluno!inner(id, usuario!inner(instituicaoensino(id))), alunoAtividade_realiza!inner(fk_trilha_id,fk_alunotrilha_realiza_id,id, acerto, feito, opcao_selecionada, atividade!inner(id, sequencia, enunciado, atividadeOpcao(sequencia, enunciado, correta), trilha(id,nome,img_url, escolaridades(id)), jogos(id)))')
        .eq('id', alunoTrilha_realiza.id)
        .single();
    var alunoTrilha = AlunoTrilhaRealiza.fromMap(response);

    return alunoTrilha;
  }

  Future<bool> trilhaJaLiberada(int trilhaID, int turmaID) async {
    final response = await Supabase.instance.client
        .from('turmaTrilha_possui')
        .select()
        .eq('fk_trilha_id', trilhaID)
        .eq('fk_turma_id', turmaID);

    return response.isNotEmpty;
  }

  Future<void> liberarTrilha(int trilhaID, int turmaID) async {
    //checar isso antes de chamar a funcao liberarTrilha para mostrar mensagem de erro. Verifica aqui denovo so por precaucao
    if (await trilhaJaLiberada(trilhaID, turmaID)) return;

    await Supabase.instance.client
        .from('turmaTrilha_possui')
        .insert({'fk_turma_id': turmaID, 'fk_trilha_id': trilhaID});

    //pra cada aluno da turma, criar a relação atividade-aluno de todas as atividades dessa trilha
    final alunos = await Supabase.instance.client
        .from('aluno')
        .select()
        .eq('fk_turma_id', turmaID);
    final atividades = await Supabase.instance.client
        .from('atividade')
        .select()
        .eq('fk_trilha_id', trilhaID);
    for (Map<String, dynamic> aluno in alunos) {
      //apaga a relacao do aluno com essa trilha caso exista (essa situacao so acontece quando o aluno tem a trilha mesmo com o trilhaJaLiberada() da turma retornando false)
      await Supabase.instance.client
          .from('alunoTrilha_realiza')
          .delete()
          .eq('fk_aluno_id', aluno['id'])
          .eq('fk_trilha_id', trilhaID);

      //cria a nova relacao alunoTrilha_realiza
      var relacao = await Supabase.instance.client
          .from('alunoTrilha_realiza')
          .insert({'fk_trilha_id': trilhaID, 'fk_aluno_id': aluno['id']})
          .select('id')
          .single();

      for (Map<String, dynamic> atividade in atividades) {
        await Supabase.instance.client.from('alunoAtividade_realiza').insert({
          'liberada': atividades[0] == atividade,
          'feito': false,
          'fk_alunotrilha_realiza_id': relacao['id'],
          'fk_trilha_id': trilhaID,
          'fk_atividade_id': atividade['id'],
        });
      }
    }
  }

  Future<List<Trilha>> getAllTrilhasEscolaridade(int idEscolaridade) async {
    final response = await Supabase.instance.client
        .from('trilha')
        .select()
        .eq('fk_escolaridades_id', idEscolaridade);

    final List<Trilha> trilhas = [];
    for (var trilha in response) {
      trilhas.add(Trilha.fromMap(trilha));
    }

    return trilhas;
  }
}
