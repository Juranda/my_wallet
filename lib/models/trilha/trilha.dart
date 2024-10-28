import 'package:my_wallet/models/escolaridade.dart';

class Trilha {
  final int id;
  final String nome;
  final String imgUrl;
  final Escolaridade escolaridade;

  Trilha(this.id, this.nome, this.imgUrl, this.escolaridade);

  factory Trilha.fromMap(Map<String, dynamic> map) {
    return Trilha(
      map['id'],
      map['nome'],
      map['img_url'] ?? "",
      map['escolaridade'],
    );
  }
}
