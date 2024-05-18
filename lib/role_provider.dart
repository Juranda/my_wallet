import 'package:flutter/material.dart';

class RoleProvider with ChangeNotifier{
  Role _role = Role.aluno;

  Role get role => _role;
  
  set role(Role newRole){
    _role = newRole;
    notifyListeners();
  }
}
enum Role {professor, aluno, moderador}
