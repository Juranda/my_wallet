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
                  TextButton(onPressed: ()=>print('click'), 
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary
                    ),
                    child: Text(
                      'Redefinir', 
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),),
                  ),),
                  
                ],
              ),
    );
  }
}