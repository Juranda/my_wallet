import 'package:my_wallet/models/turma.dart';
import 'package:my_wallet/models/users/aluno.dart';

abstract class TurmaService {
  Stream<List<Aluno>> getAlunosStream(int idTurma);

  Future<List<Turma>> getAllProfessorTurmas(int idInstituicao, int idProfessor);
  Future<Turma> getTurma(int idTurma);
  Future<List<Aluno>> getAlunosDaTurma(int idTurma);
  Future<void> adicionarAlunos(List<Aluno> alunos, int idTurma);
  Future<void> removerAlunoDaTurma(int idAluno, int idTurma);
}
