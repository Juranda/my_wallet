import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_wallet/components/logo.dart';
import 'package:my_wallet/components/mw_input.dart';
import 'package:my_wallet/role_provider.dart';
import 'package:my_wallet/styles.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  void _tryLogin(RoleProvider roleProvider) {
    // final username = usernameController.text;
    // final password = passwordController.text;

    // if (username.isEmpty || password.isEmpty) {
    //   debugPrint('Usuario ou senha vazios');

    //   return;
    // }
    switch(roleProvider.role)
    {
      case Role.professor:
        Navigator.pushReplacementNamed(context, "/home");
      break;
      case Role.aluno:
        Navigator.pushReplacementNamed(context, "/home");
      break;
      case Role.moderador:
        Navigator.pushReplacementNamed(context, "/siginup&pessoa=professor");
      break;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);

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
                    controller: usernameController,
                    onSubmit: ()=>_tryLogin(roleProvider),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyWalletInput(
                    hintText: 'Senha',
                    controller: passwordController,
                    onSubmit: ()=>_tryLogin(roleProvider),
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
                    onPressed: (){
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
                    action: ()=>_tryLogin(roleProvider),
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
