import 'package:my_wallet/models/users/administrador.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/models/users/funcao.dart';
import 'package:my_wallet/models/users/professor.dart';
import 'package:my_wallet/models/users/usuario.dart';
import 'package:my_wallet/services/exceptions/userexceptions.dart';
import 'package:my_wallet/services/implementations/supabase/postgresnt_exeption_to_message.dart';
import 'package:my_wallet/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUserService implements UserService {
  /// Tenta logar o usuario, se sucesso, retorna um Map com os dados do usuario, se nao, joga uma excessao
  Future<Usuario> login({
    required String email,
    required String senha,
  }) async {
    final supabase = Supabase.instance.client;
    AuthResponse authResponse = await supabase.auth.signInWithPassword(
      email: email,
      password: senha,
    );

    String id_supabase = authResponse.user!.id;

    var usuario = await supabase
        .from('view_usuario')
        .select()
        .eq('id_supabase', id_supabase)
        .limit(1)
        .maybeSingle();

    if (usuario == null || usuario.isEmpty) {
      throw Exception('Usuário não existe');
    }

    switch (usuario['tipo']) {
      case "PROFESSOR":
        usuario = await Supabase.instance.client
            .from('view_professor')
            .select()
            .eq('id_supabase', usuario['id_supabase'])
            .limit(1)
            .single();

        return Professor.fromMap(usuario);
      case "ALUNO":
        usuario = await Supabase.instance.client
            .from('view_aluno')
            .select()
            .eq('id_supabase', usuario['id_supabase'])
            .limit(1)
            .single();
        return Aluno.fromMap(usuario);
      case "ADMINISTRADOR":
        usuario = await Supabase.instance.client
            .from('view_administrador')
            .select()
            .eq('id_supabase', usuario['id_supabase'])
            .limit(1)
            .single();

        return Administrador.fromMap(usuario);
    }

    throw Exception('Tipo inválido');
  }

  Future<Usuario> cadastrarUsuario({
    required int idInstituicaoEnsino,
    required String nome,
    required String email,
    required String senha,
    required Funcao tipo,
  }) async {
    AuthResponse response;

    try {
      response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: senha,
      );
    } catch (e) {
      response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: senha,
      );
    }

    final User? user = response.user;

    if (user == null) {
      throw RegisterUserException('Não foi possivel cadastrar o usuário');
    }

    try {
      final result = await Supabase.instance.client
          .from('usuario')
          .insert({
            'nome': nome,
            'fk_instituicaoensino_id': idInstituicaoEnsino,
            'fk_tipousuario_id': tipo.index + 1,
            'fk_usuario_supabase': user.id
          })
          .select('id')
          .limit(1)
          .single();

      Usuario usuario = Usuario(
        idSupabase: user.id,
        idInstituicaoEnsino: idInstituicaoEnsino,
        idUsuario: result['id'],
        nome: nome,
        email: user.email!,
        tipoUsuario: tipo,
        criadoEm: DateTime.parse(user.createdAt),
      );

      return usuario;
    } on PostgrestException catch (e) {
      throw PostgrestToUserException.fromPostgrest(e);
    }
  }

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
  }) async {
    try {
      // inserir ele na tablela de usuários
      Usuario usuario = await cadastrarUsuario(
        idInstituicaoEnsino: idInstituicaoEnsino,
        nome: nome,
        email: email,
        senha: senha,
        tipo: Funcao.Aluno,
      );

      // inserir na tabela de alunos com o id
      await Supabase.instance.client.from('aluno').insert({
        'cpf': cpf.replaceAll('.', '').replaceAll('-', '').replaceAll('/', ''),
        'dinheiro': dinheiro,
        'fk_usuario_id': usuario.idUsuario,
        'fk_turma_id': idTurma,
        'fk_escolaridades_id': escolaridade,
      });
    } on PostgrestException catch (e) {
      throw PostgrestToUserException.fromPostgrest(e);
    }
  }

  Future<Aluno> getAlunoPorId(int idAluno) async {
    var aluno = await Supabase.instance.client
        .from('view_aluno')
        .select('*')
        .eq('id', idAluno)
        .limit(1)
        .single();

    return Aluno.fromMap(aluno);
  }

  Future<Aluno?> getAlunoPorEmail(String email) async {
    var aluno = await Supabase.instance.client
        .from('view_aluno')
        .select('*')
        .eq('email', email)
        .limit(1);
    if (aluno.isEmpty) return null;
    return Aluno.fromMap(aluno[0]);
  }

  @override
  Future<void> cadastrarProfessor({
    required int idInstituicaoEnsino,
    required String nome,
    required String sobrenome,
    required String email,
    required String senha,
    required String cnpjcpf,
  }) async {
    Usuario usuario = await cadastrarUsuario(
      idInstituicaoEnsino: idInstituicaoEnsino,
      nome: nome,
      email: email,
      senha: senha,
      tipo: Funcao.Professor,
    );

    await Supabase.instance.client.from('professor').insert({
      "cnpjcpf": cnpjcpf,
      "fk_usuario_id": usuario.idUsuario,
    });
  }
}
