import 'package:my_wallet/models/users/role.dart';
import 'package:my_wallet/models/users/usuario.dart';

class Administrador extends Usuario {
  final int id;

  const Administrador({
    required super.created_at,
    required super.id_supabase,
    required super.id_instituicao_ensino,
    required super.id_usuario,
    required this.id,
    required super.nome,
    required super.email,
    required super.tipoUsuario,
  });

  factory Administrador.fromMap(Map<String, dynamic> map) {
    return Administrador(
      created_at: DateTime.parse(map['created_at']),
      id_supabase: map['id_supabase'],
      id_instituicao_ensino: map['id_instituicao_ensino'],
      id_usuario: map['id_usuario'],
      id: map['id'],
      nome: map['nome'],
      tipoUsuario: Role.Administrador,
      email: map['email'],
    );
  }
}
