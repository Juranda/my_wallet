import 'package:flutter/material.dart';
import 'package:my_wallet/app/login/logo.dart';
import 'package:my_wallet/app/cadastro/mw_form_input.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/models/users/funcao.dart';
import 'package:my_wallet/models/users/usuario.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validadores/ValidarEmail.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late final UserProvider _userProvider;
  late final TurmaProvider _turmaProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
  }

  Future<void> _tryLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      Usuario usuario = await MyWallet.userService
          .login(email: emailController.text, senha: passwordController.text);
      _userProvider.setUser(usuario);

      //se aluno, pega turma_id dele
      //se professor, pega a turma_id da primeira turma que achar dele
      if (usuario.tipoUsuario == Funcao.Aluno) {
        _turmaProvider.setTurma(
            await MyWallet.turmaService.getTurma(_userProvider.aluno.idTurma));
      } else if (usuario.tipoUsuario == Funcao.Professor) {
        _turmaProvider.setTurma((await MyWallet.turmaService
                .getAllProfessorTurmas(
                    usuario.idInstituicaoEnsino, _userProvider.professor.id))
            .first);
      }

      if (_userProvider.eAdministrador) {
        Navigator.of(context).pushNamed(Routes.ADM);
        return;
      }

      Navigator.of(context).pushNamed(Routes.HOME);
    } on AuthException catch (e) {
      e.message;

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro ao logar'),
            content: Text('Suas credências são inválidas'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Logo(),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            height: constraints.maxHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Form(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      MyWalletFormInput(
                                        label: 'Email',
                                        onFieldSubmitted: (value) =>
                                            _tryLogin(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Campo obrigatório';
                                          }

                                          return EmailValidator.validate(value)
                                              ? null
                                              : "Email invalido";
                                        },
                                        controller: emailController,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      MyWalletFormInput(
                                        label: 'Senha',
                                        showText: false,
                                        controller: passwordController,
                                        onFieldSubmitted: (value) =>
                                            _tryLogin(),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        if (_formKey.currentState!.validate())
                                          _tryLogin();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        height: constraints.maxHeight / 12,
                                        width: constraints.maxWidth / 3,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ],
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Image.asset(
                                              'assets/images/seta.png',
                                              width: 30,
                                              color: Colors.white,
                                            ),
                                            const Text(
                                              'Próximo',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextLoginButton extends StatelessWidget {
  const NextLoginButton({super.key, required this.action});

  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Image.asset(
          "assets/images/seta.png",
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
