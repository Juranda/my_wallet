import 'package:flutter/foundation.dart';
import 'package:my_wallet/models/escolaridade.dart';

class Turma {
  final int id;
  final int idProfessor;
  final String escolaridadeNome;
  final int escolaridadeId;

  const Turma(
      {required this.id,
      required this.idProfessor,
      required this.escolaridadeNome,
      required this.escolaridadeId});

  factory Turma.fromMap(Map<String, dynamic> map) {
    return Turma(
        id: map['id'],
        idProfessor: map['fk_professor_id'],
        escolaridadeNome: Escolaridade.values[map['fk_escolaridades_id']].name,
        escolaridadeId: map['fk_escolaridades_id']);
  }
}
