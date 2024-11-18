import 'package:my_wallet/models/users/funcao.dart';
import 'package:my_wallet/models/users/usuario.dart';

class Aluno extends Usuario {
  final int id;
  final String cpf;
  final int? idTurma;
  final String? nomeTurma;
  final int idEscolaridade;
  final String escolaridade;

  const Aluno({
    required super.criadoEm,
    required super.idSupabase,
    required super.idInstituicaoEnsino,
    required super.idUsuario,
    required this.id,
    required super.nome,
    required super.email,
    required super.tipoUsuario,
    required this.cpf,
    required this.idTurma,
    required this.nomeTurma,
    required this.idEscolaridade,
    required this.escolaridade,
  });

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      criadoEm: DateTime.parse(map['created_at']),
      idSupabase: map['id_supabase'],
      idInstituicaoEnsino: map['id_instituicao_ensino'],
      nome: map['nome'],
      email: map['email'],
      tipoUsuario: Funcao.Aluno,
      idUsuario: map['id_usuario'],
      id: map['id'],
      cpf: map['cpf'],
      idTurma: map['id_turma'] ?? null,
      nomeTurma: map['nome_turma'] ?? null,
      idEscolaridade: map['id_escolaridade'],
      escolaridade: map['escolaridade'],
    );
  }
}
