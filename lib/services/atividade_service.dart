import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/aluno_atividade_realiza.dart';
import 'package:my_wallet/models/trilha/atividade_opcao.dart';
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
      var questoes = await Supabase.instance.client
        .from('atividadeOpcao')
        .select()
        .eq('fk_atividade_id', atv['id']);
      atv.addAll({'atividadeOpcao': questoes});

      atv.addAll({'trilha':(await Supabase.instance.client.from('trilha').select().eq('id', id_trilha).single()) }) ;
      atividades.add(Atividade.fromMap(atv));
    }

    return atividades;
  }

  Future<List<AtividadeOpcao>> getQuestoesDeAtividade(int id_atividade) async {
    var response = await Supabase.instance.client
        .from('atividadeOpcao')
        .select()
        .eq('fk_atividade_id', id_atividade);

    List<AtividadeOpcao> questoes = [];

    for (var qst in response) {
      questoes.add(AtividadeOpcao.fromMap(qst));
    }

    return questoes;
  }

}
