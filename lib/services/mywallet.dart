import 'package:my_wallet/app/models/administrador.dart';
import 'package:my_wallet/app/models/aluno.dart';
import 'package:my_wallet/app/models/professor.dart';
import 'package:my_wallet/app/models/usuario.dart';
import 'package:my_wallet/services/trailsservice.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyWallet {
  static MyWallet instance = MyWallet._();
  static TrailsService trailsService = TrailsService();

  MyWallet._();
  bool _initialized = false;

  Future<void> initialize(
      // String anonKey,
      // String url,
      ) async {
    assert(
      !instance._initialized,
      'This instance is already initialized',
    );
    await Supabase.initialize(
        url: "https://bierpaosxpulmlvgzbht.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJpZXJwYW9zeHB1bG1sdmd6Ymh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU5ODI1NTIsImV4cCI6MjAzMTU1ODU1Mn0.uxVn2A0Eo6lLAMt6o8i8RiodilGLKirfbrvK-clYhzI");
    _initialized = true;
  }

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
