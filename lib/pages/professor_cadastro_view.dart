import 'package:flutter/material.dart';
import 'package:my_wallet/components/logo.dart';
import 'package:my_wallet/components/mw_form_input.dart';
import 'package:my_wallet/pages/login_view.dart';
import 'package:my_wallet/styles.dart';
import 'package:validadores/Validador.dart';

class ProfessorCadastroView extends StatefulWidget {
  const ProfessorCadastroView({super.key});

  @override
  State<ProfessorCadastroView> createState() => _ProfessorCadastroViewState();
}

class _ProfessorCadastroViewState extends State<ProfessorCadastroView> {
  final _formKey = GlobalKey<FormState>();
  int escolaridade = 0;
  List<(String nome, int id)> escolaridades = [
    ('Escolaridade (opcional)', 0),
    ('Ensino Fundamental', 1),
    ('Ensino Médio', 2),
    ('Ensino Superior', 3),
  ];
  void _trySignIn() {
    debugPrint("hey");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Logo(),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyWalletFormInput(
                        label: 'Nome completo',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }

                          value = value.trim();

                          if (value.split(' ').length <= 1) {
                            return 'Insira o nome completo';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyWalletFormInput(
                        label: 'CPF (para comprovação de idade)',
                        textInputType: TextInputType.text,
                        validator: (value) {
                          return Validador()
                              .add(Validar.CPF, msg: 'CPF INVÁLIDO')
                              .valido(value, clearNoNumber: true);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyWalletFormInput(
                        label: 'Data de nascimento',
                        textInputType: TextInputType.datetime,
                        validator: (valor) {
                          if (valor == null) return;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const MyWalletFormInput(
                        label: 'E-mail',
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const MyWalletFormInput(
                        label: 'Usuário',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const MyWalletFormInput(
                        label: 'Senha',
                        showText: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const MyWalletFormInput(
                        label: 'Instituição de ensino',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: MyWalletFormInput(
                                label: 'Turma (opcional)',
                                isRequired: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'É aluno(a)?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, "/siginup&pessoa=aluno"),
                        child: Text(
                          'Cadastre-se aqui!',
                          style: Styles.linkTextStyle,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: NextLoginButton(
                          action: () => Navigator.pushNamed(context, "/home"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
