import 'package:flutter/material.dart';
import 'package:my_wallet/pages/account_settings/account_settings.dart';
import 'package:my_wallet/pages/account_settings/mudar_senha.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  int selectedScreen = 0;

  changeScreen(int id) {
    setState(() {
      selectedScreen = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      selectedScreen == 0
                          ? Navigator.pop(context)
                          : changeScreen(0);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 50,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.account_circle_outlined,
                  size: 150,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                Text(
                  _userProvider.nome,
                  style: TextStyle(color: Colors.white, fontSize: 40),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20),
              child: [
                AccountSettings(changeScreen),
                AccountChangePassword(),
              ][selectedScreen]),
        ],
      ),
    );
  }
}
