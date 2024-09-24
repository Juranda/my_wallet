import 'package:flutter/foundation.dart';
import 'package:my_wallet/models/escolaridade.dart';

class Turma {
  final int id;
  final int id_professor;
  final Escolaridade escolaridade;

  const Turma(
      {required this.id,
      required this.id_professor,
      required this.escolaridade});
}
