import 'package:flutter/material.dart';
import 'package:my_wallet/models/users/aluno.dart';

class AlunoListTile extends StatelessWidget {
  final Aluno aluno;
  final Function(int) removerAluno;

  const AlunoListTile(
      {super.key, required this.aluno, required this.removerAluno});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_circle_outlined),
            Text(aluno.nome),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirmação'),
              content: Text(
                  'Remover aluno da lista? (Ele não será adicionado à turma)'),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
                ElevatedButton(
                    onPressed: () {
                      removerAluno(aluno.id);
                      Navigator.pop(context);
                    },
                    child: Text('Confirmar')),
              ],
            ),
          ),
        ));
  }
}
