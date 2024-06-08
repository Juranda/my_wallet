import 'package:flutter/material.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CadastroModerador extends StatelessWidget {
  CadastroModerador({super.key});

  final cadastros = [
    (
      'Cadastrar aluno',
      Routes.ADM_CADASTRO_ALUNO,
    ),
    (
      'Cadastrar Professor',
      Routes.ADM_CADASTRO_PROFESSOR,
    ),
    (
      'Cadastrar Turma',
      Routes.ADM_CADASTRO_TURMA,
    )
  ];

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                          Navigator.pushNamed(
                            context,
                            e.$2,
                          );
                        },
                        child: Text(
                          e.$1,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
