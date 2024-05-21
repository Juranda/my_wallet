import 'package:flutter/material.dart';
import 'package:my_wallet/pages/account_settings/models/aluno.dart';
import 'package:my_wallet/pages/account_settings/models/professor.dart';
import 'package:my_wallet/pages/account_settings/models/role.dart';

import 'pages/account_settings/models/instituicao_ensino.dart';

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

  String get nome {
    return switch (role) {
      Role.professor => professor!.nome,
      Role.aluno => aluno!.nome,
      Role.moderador => instituicaoEnsino!.nome
    };
  }

  int get id_turma {
    return switch (role) {
      Role.professor => professor!.id_turma,
      Role.aluno => aluno!.id_turma,
      Role.moderador => 0,
    };
  }

  String get turma {
    return switch (role) {
      Role.professor => professor!.nome_turma,
      Role.aluno => aluno!.nome_turma,
      Role.moderador => "SEM TURMA",
    };
  }

  void setAluno(Map<String, dynamic> aluno) {
    this.aluno = Aluno(
      id: aluno['id'],
      id_usuario: aluno['id_usuario'],
      cpf: aluno['cpf'],
      nome: aluno['nome'],
      sobrenome: aluno['sobrenome'],
      email: aluno['email'],
      nome_turma: aluno['nome_turma'] ?? "",
      id_turma: aluno['id_turma'] ?? 0,
      instituicaoensino: aluno['instituicaoensino'],
      created_at: DateTime.parse(aluno['created_at']),
      escolaridade: aluno['escolaridade_turma'],
    );

    professor = null;
    instituicaoEnsino = null;
  }

  void setProfessor(Map<String, dynamic> professor) {
    this.professor = Professor(
      id: professor['id'],
      id_usuario: professor['id_usuario'],
      created_at: DateTime.parse(professor['created_at']),
      cpfcnpj: professor['cnpjcpf'],
      nome: professor['nome'],
      sobrenome: professor['sobrenome'],
      email: professor['email'],
      nome_turma: professor['nome_turma'],
      escolaridade_turma: professor['escolaridade_turma'],
      id_turma: professor['id_turma'],
      id_escolaridade: professor['id_escolaridade'],
      instituicaoensino: professor['instituicaoensino'],
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
