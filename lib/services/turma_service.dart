import 'package:my_wallet/models/turma.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TurmaService {

  Future<List<Turma>> getAllProfessorTurmas(
    int idInstituicao,
    int idProfessor
  ) async {
    final professorTurmas = await Supabase.instance.client
    .from('turma')
    .select('*')
    .eq('fk_instituicaoensino_id', idInstituicao)
    .eq('fk_professor_id', idProfessor);

    List<Turma> turmasProfessor =[];

    for (var turma in professorTurmas){
      turmasProfessor.add(Turma.fromMap(turma));
    }

    return turmasProfessor;
  }
  Future<Turma> getTurma(
    int idTurma
  )async{
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

}
