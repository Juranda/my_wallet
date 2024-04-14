import 'package:flutter/material.dart';

class AccountChangePassword extends StatefulWidget {
  const AccountChangePassword({super.key});

  @override
  State<AccountChangePassword> createState() => _AccountChangePasswordState();
}

class _AccountChangePasswordState extends State<AccountChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Form(
              child: Column(
                children: [
                  TextField(
                    
                    decoration: InputDecoration(
                      labelText: 'Senha Antiga',
                      floatingLabelBehavior: FloatingLabelBehavior.always
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nova Senha',
                      floatingLabelBehavior: FloatingLabelBehavior.always
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Confirmar Nova Senha',
                      floatingLabelBehavior: FloatingLabelBehavior.always
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: 200,
                    child: TextButton(onPressed: ()=>print('click'),
                    style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text(
                      'Redefinir', 
                      style: Theme.of(context).textTheme.labelLarge),),
                  ),
                  
                ],
              ),
    );
  }
}