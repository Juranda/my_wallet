import 'package:flutter/material.dart';
import 'package:my_wallet/models/users/funcao.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/models/users/professor.dart';
import 'package:my_wallet/models/users/administrador.dart';
import 'package:my_wallet/models/users/usuario.dart';

class UserProvider with ChangeNotifier {
  late Usuario usuario;

  Funcao get tipoUsuario {
    return usuario.tipoUsuario;
  }

  bool get eAluno => Funcao.Aluno == usuario.tipoUsuario;
  bool get eProfessor => Funcao.Professor == usuario.tipoUsuario;
  bool get eAdministrador => Funcao.Administrador == usuario.tipoUsuario;

  Aluno get aluno {
    if (tipoUsuario != Funcao.Aluno) {
      throw Exception('Tipo incorreto');
    }
    return usuario as Aluno;
  }

  Professor get professor {
    if (tipoUsuario != Funcao.Professor) {
      throw Exception('Tipo incorreto');
    }
    return usuario as Professor;
  }

  Administrador get administrador {
    if (tipoUsuario != Funcao.Administrador) {
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
