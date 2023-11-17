import 'package:flutter/material.dart';
import 'package:my_wallet/components/mw_input.dart';
import 'package:my_wallet/styles.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _tryLogin() {
    // final username = usernameController.text;
    // final password = passwordController.text;

    // if (username.isEmpty || password.isEmpty) {
    //   debugPrint('Usuario ou senha vazios');

    //   return;
    // }

    Navigator.of(context).popAndPushNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 206,
              height: 126,
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/pt/f/f1/Scrooge_McDuck.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Form(
              child: Column(
                children: [
                  MyWalletInput(
                    hintText: 'Usuário',
                    controller: usernameController,
                    onSubmit: _tryLogin,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyWalletInput(
                    hintText: 'Senha',
                    controller: passwordController,
                    onSubmit: _tryLogin,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Esqueci minha senha',
                    style: Styles.linkTextStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: Image.network(
                        "https://img.freepik.com/vetores-premium/icone-de-seta_701361-329.jpg?w=826"),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  'Não possui uma conta?',
                  style: Styles.linkTextStyle.copyWith(
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'Cadastre-se!',
                  style: Styles.linkTextStyle,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
