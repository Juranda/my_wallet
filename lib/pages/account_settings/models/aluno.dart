import 'package:my_wallet/pages/account_settings/models/escolaridade.dart';

class Aluno {
  final int id;
  final int instituicaoensino;
  final String cpf;
  final DateTime created_at;
  final String nome;
  final String sobrenome;
  final Escolaridade escolaridade;
  final int turma;
  final String id_usuario;

  Aluno({
    required this.id,
    required this.instituicaoensino,
    required this.cpf,
    required this.created_at,
    required this.nome,
    required this.sobrenome,
    required this.escolaridade,
    required this.turma,
    required this.id_usuario,
  });
}
