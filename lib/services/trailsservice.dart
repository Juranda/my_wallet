import 'package:my_wallet/models/trilha/trail.dart';
import 'package:my_wallet/models/trilha/trilha_aluno_realiza.dart';

abstract class TrailsService {
  Future<List<Trilha>> getAllTrilhas(int idInstituicaoEnsino, int idTurma);
  Future<List<TrilhaAlunoRealiza>> getAllTrilhasDoAluno(
    int idInstituicao,
    int idAluno, {
    bool cached = false,
  });
}
