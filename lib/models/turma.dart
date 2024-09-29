import 'package:flutter/foundation.dart';
import 'package:my_wallet/models/escolaridade.dart';

class Turma {
  final int id;
  final int id_professor;
  final String escolaridadeNome;
  final int escolaridadeId;

  const Turma(
      {required this.id,
      required this.id_professor,
      required this.escolaridadeNome,
      required this.escolaridadeId});


  factory Turma.fromMap(Map<String, dynamic> map){
    return Turma(
      id: map['id'], 
      id_professor: map['fk_professor_id'], 
      escolaridadeNome: map['escolaridade_nome'],
      escolaridadeId: map['fk_escolaridades_id']);
  }
}
