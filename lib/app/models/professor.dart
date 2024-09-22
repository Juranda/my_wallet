import 'package:my_wallet/app/models/role.dart';
import 'package:my_wallet/app/models/usuario.dart';

class Professor extends Usuario {
  final int id;
  final String cpfcnpj;
  final int id_usuario;

  Professor({
    required super.created_at,
    required super.id_supabase,
    required super.id_instituicao_ensino,
    required this.id_usuario,
    required this.id,
    required super.nome,
    required super.email,
    required super.tipoUsuario,
    required this.cpfcnpj,
  }) {
    super.tipoUsuario = Role.Professor;
  }

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      created_at: DateTime.parse(map['created_at']),
      id_supabase: map['id_usuario_supabase'],
      id_instituicao_ensino: map['id_instituicao_ensino'],
      id_usuario: map['id_usuario'],
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      tipoUsuario: Role.Professor,
      cpfcnpj: map['cnpjcpf'],
    );
  }
}
