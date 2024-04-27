import 'package:flutter/material.dart';
import 'package:my_wallet/components/logo.dart';
import 'package:my_wallet/components/mw_form_input.dart';
import 'package:my_wallet/pages/login_view.dart';
import 'package:my_wallet/styles.dart';
import 'package:validadores/Validador.dart';

class AlunoCadastroView extends StatefulWidget {
  const AlunoCadastroView({super.key});

  @override
  State<AlunoCadastroView> createState() => _AlunoCadastroViewState();
}

class _AlunoCadastroViewState extends State<AlunoCadastroView> {
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
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyWalletFormInput(
                        label: 'CPF (para comprovação de idade)',
                        textInputType: TextInputType.number,
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
                          return null;
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
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: DropdownButton(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  value: escolaridades[escolaridade].$2,
                                  items: escolaridades
                                      .map(
                                        (tuple) => DropdownMenuItem(
                                          value: tuple.$2,
                                          child: Text(
                                            tuple.$1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (novaEscolaridade) {
                                    setState(() {
                                      escolaridade = novaEscolaridade!;
                                    });
                                  },
                                ),
                              ),
                            ),
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
                        'É professor(a)?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, "/siginup&pessoa=professor"),
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
