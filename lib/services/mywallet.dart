import 'package:supabase_flutter/supabase_flutter.dart';

class MyWallet {
  static MyWallet instance = MyWallet._();

  MyWallet._();
  bool _initialized = false;

  void initialize() async {
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
    final AuthResponse response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: senha,
    );

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
