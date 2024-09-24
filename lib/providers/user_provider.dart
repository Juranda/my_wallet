import 'package:flutter/material.dart';
import 'package:my_wallet/models/users/role.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/models/users/professor.dart';
import 'package:my_wallet/models/users/administrador.dart';
import 'package:my_wallet/models/users/usuario.dart';

class UserProvider with ChangeNotifier {
  late Usuario usuario;

  Role get tipoUsuario {
    return usuario.tipoUsuario;
  }

  bool get eAluno => Role.Aluno == usuario.tipoUsuario;
  bool get eProfessor => Role.Professor == usuario.tipoUsuario;
  bool get eAdministrador => Role.Administrador == usuario.tipoUsuario;

  Aluno get aluno {
    if (tipoUsuario != Role.Aluno) {
      throw Exception('Tipo incorreto');
    }
    return usuario as Aluno;
  }

  Professor get professor {
    if (tipoUsuario != Role.Professor) {
      throw Exception('Tipo incorreto');
    }
    return usuario as Professor;
  }

  Administrador get administrador {
    if (tipoUsuario != Role.Administrador) {
      throw Exception('Tipo incorreto');
    }
    return usuario as Administrador;
  }

  String get nome {
    return usuario.nome;
  }

  void setUser(Usuario user) {
    this.usuario = user;
  }
}
