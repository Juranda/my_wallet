import 'package:my_wallet/models/users/funcao.dart';
import 'package:my_wallet/models/users/usuario.dart';

class Administrador extends Usuario {
  final int id;
  final int idUsuario;

  const Administrador({
    required super.criadoEm,
    required super.idSupabase,
    required super.idInstituicaoEnsino,
    required this.idUsuario,
    required this.id,
    required super.nome,
    required super.email,
    required super.tipoUsuario,
  });

  factory Administrador.fromMap(Map<String, dynamic> map) {
    return Administrador(
      criadoEm: map['created_at'],
      idSupabase: map['id_supabase'],
      idInstituicaoEnsino: map['id_instituicao_ensino'],
      idUsuario: map['id_usuario'],
      id: map['id'],
      nome: map['nome'],
      tipoUsuario: Funcao.Administrador,
      email: map['email'],
    );
  }
}
