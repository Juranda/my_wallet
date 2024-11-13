import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';

abstract class TrailsService {
  Future<List<Trilha>> getAllTrilhas(int idInstituicaoEnsino, int idTurma);
  Future<List<AlunoTrilhaRealiza>> getAllTrilhasDoAluno(
    int idInstituicao,
    int idAluno, {
    bool cached = false,
  });

  Future<AlunoTrilhaRealiza> finalizarTrilha(
      AlunoTrilhaRealiza alunoTrilha_realiza);

  Future<void> liberarTrilha(int trilhaID, int turmaID);
  Future<bool> trilhaJaLiberada(int trilhaID, int turmaID);
  Future<List<Trilha>> getAllTrilhasEscolaridade(int idEscolaridade);
}
