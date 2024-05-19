import 'package:flutter/material.dart';
import 'package:my_wallet/pages/account_settings/models/aluno.dart';
import 'package:my_wallet/pages/account_settings/models/escolaridade.dart';
import 'package:my_wallet/pages/account_settings/models/professor.dart';
import 'package:my_wallet/pages/account_settings/models/role.dart';
import 'package:provider/provider.dart';

class UserProvider with ChangeNotifier {
  InstituicaoEnsino? instituicaoEnsino;
  Aluno? aluno;
  Professor? professor;

  Role get role {
    return aluno != null
        ? Role.aluno
        : professor != null
            ? Role.professor
            : Role.moderador;
  }

  void setAluno(Map<String, dynamic> aluno) {
    this.aluno = Aluno(
      id: aluno['id'],
      instituicaoensino: aluno['instituicaoensino'],
      cpf: aluno['cpf'],
      created_at: DateTime.parse(aluno['created_at']),
      nome: aluno['nome'],
      sobrenome: aluno['sobrenome'],
      escolaridade: Escolaridade.values
          .firstWhere((element) => element.index == aluno['escolaridade']),
      turma: aluno['id_turma'],
      id_usuario: aluno['id_usuario'],
    );

    professor = null;
    instituicaoEnsino = null;
  }

  void setProfessor(Map<String, dynamic> professor) {
    this.professor = Professor(
      id: professor['id'],
      instituicaoensino: professor['instituicaoensino'],
      cpfcnpj: professor['cnpjcpf'],
      created_at: DateTime.parse(professor['created_at']),
      nome: professor['nome'],
      sobrenome: professor['sobrenome'],
      id_usuario: professor['id_usuario'],
    );

    aluno = null;
    instituicaoEnsino = null;
  }

  void setInstituicaoEnsino(Map<String, dynamic> instituicaoEnsino) {
    this.instituicaoEnsino = new InstituicaoEnsino(
        id: instituicaoEnsino['id'],
        created_at: DateTime.parse(instituicaoEnsino['created_at']),
        nome: instituicaoEnsino['nome'],
        codigoinep: instituicaoEnsino['codigoinep']);

    aluno = null;
    professor = null;
  }
}

class InstituicaoEnsino {
  final int id;
  final DateTime created_at;
  final String nome;
  final String codigoinep;

  InstituicaoEnsino({
    required this.id,
    required this.created_at,
    required this.nome,
    required this.codigoinep,
  });
}
