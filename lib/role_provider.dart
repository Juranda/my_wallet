import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Role _role = Role.aluno;
  Role get role => _role;

  set role(Role newRole) {
    _role = newRole;
    notifyListeners();
  }
}

enum Role { professor, aluno, moderador }
