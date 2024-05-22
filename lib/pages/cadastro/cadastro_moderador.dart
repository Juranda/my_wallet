import 'package:flutter/material.dart';
import 'package:my_wallet/user_provider.dart';
import 'package:provider/provider.dart';

class CadastroModerador extends StatelessWidget {
  CadastroModerador({super.key});

  final cadastros = [
    (
      'Cadastrar aluno',
      '/adm/cadastro-aluno',
    ),
    (
      'Cadastrar Professor',
      '/adm/cadastro-professor',
    ),
    ('Cadastrar Turma', '/adm/cadastro-turma')
  ];

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Gerenciador de Cadastros',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                children: [
                  Text(
                    _userProvider.nome,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cadastros
                    .map(
                      (e) => ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, e.$2);
                        },
                        child: Text(e.$1),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}