import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/components/mw_form_input.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/supabase.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validadores/ValidarCPF.dart';
import 'package:validadores/ValidarEmail.dart';

class AlunoCadastroView extends StatefulWidget {
  const AlunoCadastroView({super.key});
  @override
  State<AlunoCadastroView> createState() => _AlunoCadastroViewState();
}

class _AlunoCadastroViewState extends State<AlunoCadastroView> {
  final _formKey = GlobalKey<FormState>();
  int escolaridade = 1;
  int turmaSelecionada = 0;
  int id_instituicao_ensino = 0;
  List<(int, String)>? turmas = [];
  List<(String nome, int id)> escolaridades = [
    ('Ensino Fundamental', 1),
    ('Ensino Médio', 2),
    ('Ensino Superior', 3),
  ];

  MyWallet myWallet = MyWallet.instance;

  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _selecionaNivelEscolar(int? nivel) async {
    if (nivel == null) return;

    final turmasNovas = await Supabase.instance.client
        .from('turma')
        .select('id, nome')
        .eq('id_instituicao_ensino', id_instituicao_ensino)
        .eq('nivel_escolaridade', nivel);

    setState(() {
      escolaridade = nivel;

      if (turmasNovas.isNotEmpty) {
        turmas = turmasNovas
            .map((t) => (t['id'] as int, t['nome'] as String))
            .toList();
        turmaSelecionada = turmasNovas.first['id'];
        return;
      }

      turmas = null;
    });
  }

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = Provider.of(context, listen: false);
    id_instituicao_ensino = userProvider.instituicaoEnsino!.id;
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
                Center(
                  child: Text(
                    'Cadastrar novo Aluno',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
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
                        controller: nomeController,
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
                        label: 'CPF',
                        controller: cpfController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter()
                        ],
                        textInputType: TextInputType.number,
                        validator: (value) {
                          return CPF.isValid(value) ? null : "CPF Inválido";
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyWalletFormInput(
                        label: 'Data de nascimento',
                        controller: dataNascimentoController,
                        textInputType: TextInputType.datetime,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          DataInputFormatter(),
                        ],
                        validator: (valor) {
                          if (valor != null) {}

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyWalletFormInput(
                        label: 'E-mail',
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) => EmailValidator.validate(value)
                            ? null
                            : "Email inválido",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyWalletFormInput(
                        label: 'Senha',
                        showText: false,
                        controller: passwordController,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return "Senha vazia!";
                          }

                          if (password.length < 8) {
                            return "Senha muito pequena";
                          }

                          // Contains at least one uppercase letter
                          if (!password.contains(RegExp(r'[A-Z]'))) {
                            return '• Pelomenos 1 letra maiúscula';
                          }
                          // Contains at least one lowercase letter
                          if (!password.contains(RegExp(r'[a-z]'))) {
                            return '• Pelomenos 1 letra minúscula';
                          }
                          // Contains at least one digit
                          if (!password.contains(RegExp(r'[0-9]'))) {
                            return '• Pelomenos 1 numero.';
                          }
                          // Contains at least one special character
                          if (!password
                              .contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
                            return '• Pelomenos 1 caracter especial.';
                          }
                          // If there are no error messages, the password is valid
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            value: escolaridades[escolaridade - 1].$2,
                            items: escolaridades
                                .map(
                                  (tuple) => DropdownMenuItem(
                                    value: tuple.$2,
                                    child: Text(
                                      tuple.$1,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: _selecionaNivelEscolar,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton(
                            isExpanded: true,
                            value: turmaSelecionada,
                            items: turmas
                                ?.map(
                                  (e) => DropdownMenuItem(
                                    child: Text(
                                      'Turma ' + e.$2,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    value: e.$1,
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                turmaSelecionada = value;
                              });
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            myWallet.cadastrarAluno(
                              idInstituicaoEnsino: id_instituicao_ensino,
                              nome: nomeController.text.substring(
                                  0, nomeController.text.indexOf(" ")),
                              sobrenome: nomeController.text
                                  .substring(nomeController.text.indexOf(" ")),
                              cpf: cpfController.text,
                              email: emailController.text,
                              senha: passwordController.text,
                              escolaridade: escolaridade,
                              idTurma: turmaSelecionada,
                              dinheiro: 1000,
                            );

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content:
                                    const Text('Aluno cadastrado com sucesso!'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Ok'),
                                  )
                                ],
                              ),
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Text(e.toString());
                              },
                            );
                          }
                        },
                        child: const Text('Cadastrar'),
                      )
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
