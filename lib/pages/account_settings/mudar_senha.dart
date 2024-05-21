import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountChangePassword extends StatefulWidget {
  const AccountChangePassword({super.key});

  @override
  State<AccountChangePassword> createState() => _AccountChangePasswordState();
}

class _AccountChangePasswordState extends State<AccountChangePassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  void redefinirSenha() {
    Supabase.instance.client.auth
        .updateUser(UserAttributes(password: newPasswordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              return value!.isEmpty ? 'insira uma senha' : null;
            },
            controller: oldPasswordController,
            decoration: InputDecoration(
                labelText: 'Senha Antiga',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextField(
            controller: newPasswordController,
            decoration: InputDecoration(
                labelText: 'Nova Senha',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextField(
            controller: confirmNewPasswordController,
            decoration: InputDecoration(
                labelText: 'Confirmar Nova Senha',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 200,
            child: TextButton(
              onPressed: () => print('click'),
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary),
              child: Text('Redefinir',
                  style: Theme.of(context).textTheme.labelLarge),
            ),
          ),
        ],
      ),
    );
  }
}
