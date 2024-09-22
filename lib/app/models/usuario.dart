import 'package:my_wallet/app/models/role.dart';

abstract class Usuario {
  final int id_supabase;
  final int id_instituicao_ensino;
  final String nome;
  late final Role tipoUsuario;
  final DateTime created_at;
  final String email;

  Usuario({
    required this.id_supabase,
    required this.nome,
    required this.id_instituicao_ensino,
    required this.tipoUsuario,
    required this.created_at,
    required this.email,
  });
}
