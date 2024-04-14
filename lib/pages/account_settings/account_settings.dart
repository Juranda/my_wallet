import 'package:flutter/material.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings(this.changeScreen);

  final void Function(int) changeScreen;
  
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(
        onPressed: () {
          changeScreen(1);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Text(
            'Mudar Senha',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary, fontSize: 25),
          ),
        ),
      ),
      TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Text(
              'Logout',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 25),
            ),
          ))
    ]);
  }
}
