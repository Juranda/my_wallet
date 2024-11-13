import 'package:my_wallet/models/escolaridade.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrilhaService {
  Future<List<Trilha>> getAllTrilhasTurma(
      int idInstituicaoEnsino, int idTurma) async {
    final response = await Supabase.instance.client
        .from('turmaTrilha_possui')
        .select(
            'trilha(id, nome, img_url, fk_escolaridades_id)')
        .eq('turma.id', idTurma);
    final trilhas = <Trilha>[];


    for (var trilha in response) {
      trilhas.add(Trilha.fromMap(trilha));
    }

    return trilhas;
  }


  Future<List<AlunoTrilhaRealiza>> getAllAlunoTrilhaRealiza(
    int trilhaId,
    int turmaId
  )async{
    var alunos = await Supabase.instance.client.from('aluno').select().eq('fk_turma_id',turmaId);
    List<AlunoTrilhaRealiza> alunoTrilhaRealiza = [];

    for (var aluno in alunos) {
      var response = await Supabase.instance.client.from('alunoTrilha_realiza').select().eq('fk_aluno_id', aluno['id']).single();
      alunoTrilhaRealiza.add(AlunoTrilhaRealiza.fromMap(response));
    }
    return alunoTrilhaRealiza;
  }

  Future<List<Trilha>> getAllTrilhasEscolaridade(int idEscolaridade) async {
    final response = await Supabase.instance.client
        .from('trilha')
        .select()
        .eq('fk_escolaridades_id', idEscolaridade);

    final List<Trilha>trilhas = [];
    for (var trilha in response) {
      trilhas.add(Trilha.fromMap(trilha));
    }

    return trilhas;
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

  Future<List<Atividade>> getAllAtividadesDeTrilha(
    int trilhaID
  )async{
    List<Atividade> atividades = [];
    var response = await Supabase.instance.client.from('atividade').select().eq('fk_trilha_id', trilhaID);

    for (var atividade in response) {
      atividades.add(Atividade.fromMap(atividade));
    }

    return atividades;
  }


  Future<List<AlunoTrilhaRealiza>> getAllTrilhasDoAluno(
    int idInstituicao,
    int idAluno, {
    bool cached = false,
  }) async {
    final alunoTrilhas;

    alunoTrilhas = await Supabase.instance.client
        .from('alunoTrilha_realiza')
        .select(
            'id, pontuacao, completada_em, trilha(id, nome, fk_escolaridades_id, img_url), aluno!inner(id, usuario!inner(instituicaoensino(id))), alunoAtividade_realiza!inner(fk_trilha_id,fk_alunotrilha_realiza_id,id, acerto, feito, opcao_selecionada, atividade!inner(id, sequencia, enunciado, atividadeOpcao(sequencia, enunciado, correta), trilha(id,nome,img_url,fk_escolaridades_id), jogos(id)))')
        .eq('aluno.usuario.instituicaoensino.id', idInstituicao)
        .eq('aluno.id', idAluno);

    List<AlunoTrilhaRealiza> alunoTrilhaRealiza = [];

    for (var alunoTrilha in alunoTrilhas) {
      alunoTrilhaRealiza.add(AlunoTrilhaRealiza.fromMap(alunoTrilha));
    }
    return alunoTrilhaRealiza;
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
            'id, pontuacao, completada_em, trilha(id, nome, fk_escolaridades_id, img_url), aluno!inner(id, usuario!inner(instituicaoensino(id))), alunoAtividade_realiza!inner(fk_trilha_id,fk_alunotrilha_realiza_id,id, acerto, feito, opcao_selecionada, atividade!inner(id, sequencia, enunciado, atividadeOpcao(sequencia, enunciado, correta), trilha(id,nome,img_url,fk_escolaridades_id), jogos(id)))')
        .eq('id', alunoTrilha_realiza.id)
        .single();
    var alunoTrilha = AlunoTrilhaRealiza.fromMap(response);

    return alunoTrilha;
  }
}
