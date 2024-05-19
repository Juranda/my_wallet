import 'package:flutter/material.dart';

class AlunoListTile extends StatelessWidget {
  final String nome;
  final int tileID;
  final Function(int) removerAluno;

  const AlunoListTile(
      {super.key,
      required this.nome,
      required this.tileID,
      required this.removerAluno});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_circle_outlined),
          Text(nome),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => removerAluno(tileID),
      ),
    );
  }
}
