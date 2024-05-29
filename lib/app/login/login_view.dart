import 'package:flutter/material.dart';
import 'package:my_wallet/app/login/logo.dart';
import 'package:my_wallet/app/cadastro/mw_form_input.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/providers/user_provider.dart';
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
  Future<void> _tryLogin(UserProvider userProvider) async {
    setState(() {
      isLoading = true;
    });

    final supabase = Supabase.instance.client;

    try {
      late AuthResponse authResponse;

      await supabase.auth
          .signInWithPassword(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((value) => authResponse = value)
          .catchError((error) => throw error);

      String id_usuario = authResponse.user!.id;
      final aluno = await supabase
          .from('view_aluno')
          .select()
          .eq('id_usuario', id_usuario)
          .limit(1)
          .maybeSingle();

      if (aluno != null && aluno.isNotEmpty) {
        userProvider.setAluno(aluno);

        Navigator.pushNamed(context, Routes.HOME);

        return;
      }

      final professor = await supabase
          .from('view_professor')
          .select()
          .eq('id_usuario', id_usuario)
          .limit(1)
          .maybeSingle();

      if (professor != null && professor.isNotEmpty) {
        userProvider.setProfessor(professor);
        Navigator.pushNamed(context, Routes.HOME);
        return;
      }

      final instituicao_ensino = await supabase
          .from('instituicaoensino')
          .select()
          .eq('id_usuario', id_usuario)
          .limit(1)
          .maybeSingle();

      if (instituicao_ensino != null && instituicao_ensino.isNotEmpty) {
        userProvider.setInstituicaoEnsino(instituicao_ensino);
        Navigator.pushNamed(context, Routes.ADM);
        return;
      }

      Navigator.pushNamed(
        context,
        Routes.SIGNUP_DELETAR,
        arguments: "professor",
      );
    } on AuthException catch (e) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro ao logar'),
            content: Text(e.message),
            actions: [
              const Text('Ok'),
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Material(
      color: Theme.of(context).colorScheme.background,
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
                        debugPrint("Altura maxima ${constraints.maxHeight}");
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
                                          _tryLogin(userProvider),
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
                                          _tryLogin(userProvider),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  children: [
                                    Text(
                                      'Próx.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                    NextLoginButton(
                                      action: () => {
                                        if (_formKey.currentState!.validate())
                                          _tryLogin(userProvider)
                                      },
                                    ),
                                  ],
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
