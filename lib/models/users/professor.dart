import 'package:my_wallet/models/users/role.dart';
import 'package:my_wallet/models/users/usuario.dart';

class Professor extends Usuario {
  final int id;
  final String cpfcnpj;
  String turmaAtual = "";

  Professor({
    required super.id_usuario,
    required super.created_at,
    required super.id_supabase,
    required super.id_instituicao_ensino,
    required this.id,
    required super.nome,
    required super.email,
    required super.tipoUsuario,
    required this.cpfcnpj,
  });

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      created_at: DateTime.parse(map['created_at']),
      id_supabase: map['id_supabase'],
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
