import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/aluno_atividade_realiza.dart';
import 'package:my_wallet/models/trilha/atividade_questao.dart';
import 'package:my_wallet/models/escolaridade.dart';
import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrilhaService {
  Future<List<Trilha>> getAllTrilhasTurma(
      int idInstituicaoEnsino, int idTurma) async {
    final maps = await Supabase.instance.client
        .from('turmaTrilha_possui')
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

  Future<List<Trilha>> getAllTrilhasEscolaridade(int idEscolaridade) async {
    final maps = await Supabase.instance.client
        .from('trilha')
        .select()
        .eq('fk_escolaridades_id', idEscolaridade);

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

  Future<bool> trilhaJaLiberada(
    int trilhaID,
    int turmaID    
    ) async {
    final response = await Supabase.instance.client
        .from('turmaTrilha_possui')
        .select()
        .eq('fk_trilha_id', trilhaID)
        .eq('fk_turma_id', turmaID);

    return response.isNotEmpty;
  }

  Future<void> liberarTrilha(
    int trilhaID,
    int turmaID
    ) async {
    if (await trilhaJaLiberada(trilhaID, turmaID)) return;

    await Supabase.instance.client.from('turmaTrilha_possui').insert(
        {'fk_turma_id': turmaID, 'fk_trilha_id': trilhaID});

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
      await Supabase.instance.client.from('alunoTrilha_realiza')
      .delete()
      .eq('fk_aluno_id', aluno['id'])
      .eq('fk_trilha_id', trilhaID);

      await Supabase.instance.client.from('alunoTrilha_realiza')
      .insert({
        'fk_trilha_id': trilhaID,
        'fk_aluno_id': aluno['id']
      });

      for (Map<String, dynamic> atividade in atividades) {

        await Supabase.instance.client.from('alunoAtividade_completa').insert({
          'liberada': atividades[0] == atividade,
          'feito': false,
          'fk_aluno_id': aluno['id'],
          'fk_atividade_id': atividade['id']
        });
      }
    }
  }
  Future<List<AlunoTrilhaRealiza>> getAllTrilhasDoAluno(
    int idInstituicao,
    int idAluno, {
    bool cached = false,
  }) async {
    final alunoTrilhas;

    alunoTrilhas = await Supabase.instance.client
        .from('alunoTrilha_realiza')
        .select('id, pontuacao, completada_em, trilha(id, nome, escolaridades(id, nome)), aluno!inner(id, usuario!inner(instituicaoensino(id))), alunoAtividade_completa!inner(id, acerto, feito, opcao_selecionada, atividade!inner(id, sequencia, enunciado, atividadeQuestao(sequencia, enunciado, correta), jogos(id)))');
       
        //.eq('aluno.usuario.instituicaoensino.id', idInstituicao)
        //.eq('aluno.id', idAluno);
    
        

    List<AlunoTrilhaRealiza> trilhasAluno = [];

    for (var alunoTrilha in alunoTrilhas) {
      List<AlunoAtividadeRealiza> atividades = [];
      var trilhaMap = alunoTrilha['trilha'];
      var trilha = Trilha(
        trilhaMap['id'],
        trilhaMap['nome'],
        trilhaMap['img_url'] ?? "",
        Escolaridade.values.elementAt(trilhaMap['escolaridades']['id'] - 1),
      );

      for (Map<String, dynamic> atividadeCompletaAluno
          in alunoTrilha['alunoAtividade_completa']) {
        var respostas = atividadeCompletaAluno['atividade']['atividadeQuestao']
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

        atividades.add(AlunoAtividadeRealiza(
          idTrilha: alunoTrilha['trilha']['id'],
          idAlunoTrilhaRealiza: alunoTrilha['id'],
          id: atividadeCompletaAluno['id'],
          acerto: (atividadeCompletaAluno['acerto']),
          opcaoSelecionada: atividadeCompletaAluno['opcao_selecionada'],
          feito: atividadeCompletaAluno['feito'],
          atividade: atividade,
        ));
      }

      trilhasAluno.add(AlunoTrilhaRealiza(
        id: alunoTrilha['id'],
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
