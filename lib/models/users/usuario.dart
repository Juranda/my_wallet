// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:my_wallet/models/users/role.dart';

class Usuario {
  final int id_usuario;
  final String id_supabase;
  final int id_instituicao_ensino;
  final String nome;
  final Role tipoUsuario;
  final DateTime created_at;
  final String email;

  const Usuario({
    required this.id_usuario,
    required this.id_supabase,
    required this.nome,
    required this.id_instituicao_ensino,
    required this.tipoUsuario,
    required this.created_at,
    required this.email,
  });
}
