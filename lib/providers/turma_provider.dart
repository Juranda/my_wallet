import 'package:flutter/material.dart';
import 'package:my_wallet/models/turma.dart';

class TurmaProvider with ChangeNotifier {
  late Turma _turma;

  Turma get turma {
    return _turma;
  }

  void setTurma(Turma turma) {
    this._turma = turma;
  }
}
