import 'package:my_wallet/models/users/funcao.dart';
import 'package:my_wallet/models/users/usuario.dart';

class Professor extends Usuario {
  final int id;
  final String cpfcnpj;
  final int idUsuario;

  const Professor({
    required super.criadoEm,
    required super.idSupabase,
    required super.idInstituicaoEnsino,
    required this.idUsuario,
    required this.id,
    required super.nome,
    required super.email,
    required super.tipoUsuario,
    required this.cpfcnpj,
  });

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      criadoEm: DateTime.parse(map['created_at']),
      idSupabase: map['id_usuario_supabase'],
      idInstituicaoEnsino: map['id_instituicao_ensino'],
      idUsuario: map['id_usuario'],
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      tipoUsuario: Funcao.Professor,
      cpfcnpj: map['cnpjcpf'],
    );
  }
}
