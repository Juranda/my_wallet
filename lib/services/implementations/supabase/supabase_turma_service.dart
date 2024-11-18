import 'package:my_wallet/models/turma.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/services/turma_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTurmaService implements TurmaService {
  Future<List<Turma>> getAllProfessorTurmas(
      int idInstituicao, int idProfessor) async {
    final professorTurmas = await Supabase.instance.client
        .from('turma')
        .select('*')
        .eq('fk_instituicaoensino_id', idInstituicao)
        .eq('fk_professor_id', idProfessor);

    List<Turma> turmasProfessor = [];

    for (var turma in professorTurmas) {
      turmasProfessor.add(Turma.fromMap(turma));
    }

    return turmasProfessor;
  }

  Future<Turma> getTurma(int idTurma) async {
    final turma = await Supabase.instance.client
        .from('turma')
        .select()
        .eq('id', idTurma)
        .limit(1)
        .single();

    final escolaridadeNome = await Supabase.instance.client
        .from('escolaridades')
        .select('nome')
        .eq('id', turma['id'])
        .limit(1)
        .single();

    turma.addAll({'escolaridade_nome': escolaridadeNome['nome']});
    return Turma.fromMap(turma);
  }

  Future<List<Aluno>> getAlunosDaTurma(int idTurma) async {
    var response = await Supabase.instance.client
        .from('view_aluno')
        .select('*')
        .eq('id_turma', idTurma);
    List<Aluno> alunos = [];
    for (var aluno in response) {
      alunos.add(Aluno.fromMap(aluno));
    }

    return alunos;
  }

  Stream<List<Aluno>> getAlunosStream(int idTurma) {
    return Supabase.instance.client
        .from('aluno')
        .stream(primaryKey: ['id']).asyncMap((event) async {
      return await getAlunosDaTurma(idTurma);
    });
  }

  Future<void> adicionarAlunos(List<Aluno> alunos, int idTurma) async {
    for (var aluno in alunos) {
      await Supabase.instance.client.from('aluno').update(
        {
          'fk_turma_id': idTurma,
        },
      ).eq('id', aluno.id);
    }
  }

  @override
  Future<void> removerAlunoDaTurma(int idAluno, int idTurma) async {
    await Supabase.instance.client
        .from('aluno')
        .update({'fk_turma_id': null}).eq('id', idAluno);
  }
}
