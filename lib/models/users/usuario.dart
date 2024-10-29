import 'package:my_wallet/models/users/funcao.dart';

abstract class Usuario {
  final String idSupabase;
  final int idInstituicaoEnsino;
  final String nome;
  final Funcao tipoUsuario;
  final DateTime criadoEm;
  final String email;

  const Usuario({
    required this.idSupabase,
    required this.nome,
    required this.idInstituicaoEnsino,
    required this.tipoUsuario,
    required this.criadoEm,
    required this.email,
  });
}
