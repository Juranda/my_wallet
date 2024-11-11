import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/models/users/role.dart';
import 'package:my_wallet/models/users/usuario.dart';

abstract class UserService {
  /// Loga usando o email e a senha, se o usuário já existir joga uma excessao
  Future<Usuario> login({
    required String email,
    required String senha,
  });

  Future<Usuario> cadastrarUsuario({
    required int idInstituicaoEnsino,
    required String nome,
    required String email,
    required String senha,
    required Role tipo,
  });

  Future<void> cadastrarAluno({
    required int idInstituicaoEnsino,
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    required String cpf,
    required int escolaridade,
    required int idTurma,
    double dinheiro = 100.0,
  });

  Future<void> cadastrarProfessor({
    required int idInstituicaoEnsino,
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    required String cnpjcpf,
  });

  Future<Aluno> getAluno(int idAluno, int idInstituicao);
}
