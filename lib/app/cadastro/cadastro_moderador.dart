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
      appBar: AppBar(
        title: const Text('Gerenciador de cadastros'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 20),
                    text: 'Instituição de Ensino: ',
                    children: [
                      TextSpan(
                        text: _userProvider.nome,
                      ),
                    ],
                  ),
                ),
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
                            color: Theme.of(context).primaryColor,
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
