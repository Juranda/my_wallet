import 'package:my_wallet/app/models/role.dart';
import 'package:my_wallet/app/models/usuario.dart';

class Aluno extends Usuario {
  final int id_usuario;
  final int id;
  final String cpf;
  final int id_turma;
  final String nome_turma;
  final int id_escolaridade;
  final String escolaridade;

  const Aluno({
    required super.created_at,
    required super.id_supabase,
    required super.id_instituicao_ensino,
    required this.id_usuario,
    required this.id,
    required super.nome,
    required super.email,
    required super.tipoUsuario,
    required this.cpf,
    required this.id_turma,
    required this.nome_turma,
    required this.id_escolaridade,
    required this.escolaridade,
  });

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      created_at: DateTime.parse(map['created_at']),
      id_supabase: map['id_supabase'],
      id_instituicao_ensino: map['id_instituicao_ensino'],
      nome: map['nome'],
      email: map['email'],
      tipoUsuario: Role.Aluno,
      id_usuario: map['id_usuario'],
      id: map['id'],
      cpf: map['cpf'],
      id_turma: map['id_turma'] ?? 0,
      nome_turma: map['nome_turma'] ?? "",
      id_escolaridade: map['id_escolaridade'],
      escolaridade: map['escolaridade'],
    );
  }
}
