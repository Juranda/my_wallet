import 'package:flutter/material.dart';
import 'package:my_wallet/user_provider.dart';
import 'package:provider/provider.dart';

import '../pages/account_settings/models/role.dart';

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
    UserProvider _user_provider = Provider.of<UserProvider>(context);

    return ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_circle_outlined),
          Text(nome),
        ],
      ),
      trailing: _user_provider.role == Role.professor
          ? IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => removerAluno(tileID),
            )
          : null,
    );
  }
}
