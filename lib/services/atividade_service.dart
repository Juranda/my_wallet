import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/aluno_atividade_realiza.dart';
import 'package:my_wallet/models/trilha/atividade_questao.dart';
import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AtividadeService {
  // Future<List<AtividadeAlunoRealiza>> getAtividadeAlunoRealizaDeTrilha(int idAluno, int id_trilha)async{
  //   var AtividadeAlunoRealiza = await Supabase.instance.client
  //   .from('alunoAtividade_realiza')
  //   .select()
  //   .eq('fk_trilha_id', id_trilha)
  //   .eq('fk_aluno_id', id_trilha)
  // }

  Future<List<Atividade>> getAtividadesDeTrilha(int id_trilha) async {
    var response = await Supabase.instance.client
        .from('atividade')
        .select()
        .eq('fk_trilha_id', id_trilha);

    List<Atividade> atividades = [];

    for (var atv in response) {
      List<AtividadeQuestao> questoes = await getQuestoesDeAtividade(atv['id']);
      atv.addAll({'respostas': questoes});
      atividades.add(Atividade.fromMap(atv));
    }

    return atividades;
  }

  Future<List<AtividadeQuestao>> getQuestoesDeAtividade(
      int id_atividade) async {
    var response = await Supabase.instance.client
        .from('atividadeQuestao')
        .select()
        .eq('fk_atividade_id', id_atividade);

    List<AtividadeQuestao> questoes = [];

    for (var qst in response) {
      questoes.add(AtividadeQuestao.fromMap(qst));
    }

    return questoes;
  }

  Future<AlunoTrilhaRealiza> finalizarTrilha(
      AlunoTrilhaRealiza aluno_realiza) async {
    for (var atividade in aluno_realiza.atividades) {
      await Supabase.instance.client
          .from('alunoAtividade_realiza')
          .update({'opcao_selecionada': atividade.opcaoSelecionada}).eq(
              'id', atividade.id);
    }

    return aluno_realiza;

    var response = await Supabase.instance.client
        .from('alunoTrilha_realiza')
        .select('*, trilha(*)')
        .eq('id', aluno_realiza.id)
        .limit(1)
        .single();
    response.addAll({'trilha': Trilha.fromMap(response['trilha'])});
    return AlunoTrilhaRealiza.fromMap(response);
  }
}
