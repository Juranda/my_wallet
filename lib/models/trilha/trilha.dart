import 'package:my_wallet/models/escolaridade.dart';

class Trilha {
  final int id;
  final String nome;
  final String imgUrl;
  final Escolaridade escolaridade;

  Trilha({
    required this.id,
    required this.nome,
    required this.imgUrl,
    required this.escolaridade,
  });

  factory Trilha.fromMap(Map<String, dynamic> map) {
    return Trilha(
      id: map['id'],
      nome: map['nome'],
      imgUrl: map['img_url'] != null ? map['img_url'] : "",
      escolaridade: Escolaridade.values[map['fk_escolaridades_id'] - 1],
    );
  }
}
