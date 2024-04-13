import 'package:flutter/material.dart';
import 'package:my_wallet/settings_provider.dart';
import 'package:provider/provider.dart';

class AppSettingsView extends StatefulWidget {
  const AppSettingsView({super.key});

  @override
  State<AppSettingsView> createState() => _AppSettingsViewState();
}

class _AppSettingsViewState extends State<AppSettingsView>
    with AutomaticKeepAliveClientMixin<AppSettingsView> {
  bool modoBlack = false;

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings =
        Provider.of<SettingsProvider>(context, listen: false);

    super.build(context);
    return Column(
      children: [
        Container(
          height: 60,
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          child: Center(
            child: Text(
              'Configurações',
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modo escuro',
                    style: TextStyle(fontSize: 30),
                  ),
                  Switch(
                    value: settings.isDarkMode,
                    onChanged: (value) => {
                      setState(
                        () {
                          settings.toggleDarkMode();
                        },
                      ),
                    },
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Audio dos Jogos',
                  style: TextStyle(fontSize: 30),
                ),
                Switch(
                  value: false,
                  onChanged: (value) => {value = !value},
                ),
              ]),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
        )
      ],
    );
  }
}
