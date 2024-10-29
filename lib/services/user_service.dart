import 'package:my_wallet/models/users/administrador.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/models/users/professor.dart';
import 'package:my_wallet/models/users/usuario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
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

    String idSupabase = authResponse.user!.id;

    var usuario = await supabase
        .from('view_usuario')
        .select()
        .eq('id_supabase', idSupabase)
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

  void cadastrarAluno({
    required int idInstituicaoEnsino,
    required String nome,
    required String sobrenome,
    required String cpf,
    required String email,
    required String senha,
    required int escolaridade,
    required int idTurma,
    double dinheiro = 100.0,
  }) async {
    AuthResponse response;

    try {
      response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: senha,
      );
    } on AuthApiException {
      response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: senha,
      );
    }

    final User user = response.user!;

    await Supabase.instance.client.from('aluno').insert({
      'instituicaoensino': idInstituicaoEnsino,
      'cpf': cpf,
      'nome': nome,
      'sobrenome': sobrenome,
      'escolaridade': escolaridade,
      'papel': 1,
      'dinheiro': dinheiro,
      'id_usuario': user.id,
      'id_turma': idTurma
    });
  }
}
