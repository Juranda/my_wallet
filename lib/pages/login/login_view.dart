import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_wallet/components/logo.dart';
import 'package:my_wallet/components/mw_input.dart';
import 'package:my_wallet/role_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Future<void> _tryLogin(UserProvider roleProvider) async {
    final supabase = Supabase.instance.client;
    AuthResponse? authResponse;

    try {
      authResponse = await supabase.auth.signInWithPassword(
          email: emailController.text, password: passwordController.text);
      String id_usuario = authResponse.user!.id;
      final aluno = await supabase
          .from('aluno')
          .select()
          .eq('id_usuario', id_usuario)
          .limit(1)
          .maybeSingle();

      if (aluno != null && aluno.isNotEmpty) {
        Navigator.pushReplacementNamed(context, "/home");

        return;
      }

      final professor = await supabase
          .from('professor')
          .select()
          .eq('id_usuario', id_usuario);

      if (professor != null && professor.isNotEmpty) {
        roleProvider.role = Role.professor;

        Navigator.pushReplacementNamed(context, "/home");
        return;
      }

      Navigator.pushReplacementNamed(context, "/siginup&pessoa=professor");
    } on AuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: Center(
              child: Text(e.message),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<UserProvider>(context, listen: false);

    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Logo(),
            Form(
              child: Column(
                children: [
                  MyWalletInput(
                    hintText: 'Usuário',
                    controller: emailController,
                    onSubmit: () => _tryLogin(roleProvider),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyWalletInput(
                    hintText: 'Senha',
                    controller: passwordController,
                    onSubmit: () => _tryLogin(roleProvider),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Logar como professor (apenas para testes)"),
                  Switch(
                    value: roleProvider.role == Role.professor,
                    thumbColor: MaterialStatePropertyAll(Colors.black),
                    trackOutlineColor: MaterialStatePropertyAll(Colors.black),
                    onChanged: (_) {
                      setState(
                        () {
                          roleProvider.role =
                              roleProvider.role == Role.professor
                                  ? Role.aluno
                                  : Role.professor;
                        },
                      );
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        roleProvider.role = Role.moderador;
                        _tryLogin(roleProvider);
                      },
                      child: Text('Logar como moderador (testes)'))
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  Text(
                    'Próx.',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  NextLoginButton(
                    action: () => _tryLogin(roleProvider),
                  ),
                ],
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