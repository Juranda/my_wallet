import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/app/cadastro/mw_form_input.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validadores/ValidarCNPJ.dart';
import 'package:validadores/ValidarCPF.dart';
import 'package:validadores/ValidarEmail.dart';

class ProfessorCadastroView extends StatefulWidget {
  const ProfessorCadastroView({super.key});

  @override
  State<ProfessorCadastroView> createState() => _ProfessorCadastroViewState();
}

class _ProfessorCadastroViewState extends State<ProfessorCadastroView> {
  int id_instituicao_ensino = 0;
  List<(int, String)>? turmas = [];
  List<(String nome, int id)> escolaridades = [
    ('Ensino Fundamental', 1),
    ('Ensino Médio', 2),
    ('Ensino Superior', 3),
  ];

  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserProvider userProvider = Provider.of(context);
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
                    'Cadastrar novo Professor',
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
                        label: 'CNPJ/CPF',
                        controller: cpfController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfOuCnpjFormatter()
                        ],
                        textInputType: TextInputType.number,
                        validator: (value) {
                          return CPF.isValid(value) || CNPJ.isValid(value)
                              ? null
                              : "CPF Inválido";
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
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final AuthResponse response =
                                await Supabase.instance.client.auth.signUp(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            final User user = response.user!;

                            await Supabase.instance.client
                                .from('professor')
                                .insert({
                              'instituicaoensino': id_instituicao_ensino,
                              'cnpjcpf': cpfController.text,
                              'nome': nomeController.text.substring(
                                  0, nomeController.text.indexOf(" ")),
                              'sobrenome': nomeController.text
                                  .substring(nomeController.text.indexOf(" ")),
                              'papel': 2,
                              'id_usuario': user.id
                            });
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Text(
                                      'Professor cadastrado com sucesso!');
                                });
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
