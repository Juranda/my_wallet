import 'package:flutter/material.dart';
import 'package:my_wallet/app/models/role.dart';
import 'package:my_wallet/app/models/aluno.dart';
import 'package:my_wallet/app/models/professor.dart';
import 'package:my_wallet/app/models/administrador.dart';
import 'package:my_wallet/app/models/usuario.dart';

class UserProvider with ChangeNotifier {
  late Usuario usuario;

  Role get tipoUsuario {
    return usuario.tipoUsuario;
  }

  Aluno get aluno {
    return usuario as Aluno;
  }

  Professor get professor {
    return usuario as Professor;
  }

  Administrador get administrador {
    return usuario as Administrador;
  }

  String get nome {
    return usuario.nome;
  }

  void setUser(Map<String, dynamic> user) {
    Role role = Role.values
        .firstWhere((element) => element.name == user['tipoUsuario']);

    switch (role) {
      case Role.Professor:
        this.usuario = Professor.fromMap(user);
        break;
      case Role.Aluno:
        this.usuario = Aluno.fromMap(user);
        break;
      case Role.Administrador:
        this.usuario = Administrador.fromMap(user);
        break;
    }
  }
}
