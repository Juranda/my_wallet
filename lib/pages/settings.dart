import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:my_wallet/context-providers/DarkModeContextProvider.dart';
import 'package:my_wallet/pages/profile_status.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool modoEscuro = false;
  bool audioDosJogos = false;

  @override
  Widget build(BuildContext context) {
    DarkModeContextProvider? provider = DarkModeContextProvider.of(context);
    if (provider == null) {
      throw Exception("Precisamos de um provider");
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Container(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProfileStatus(),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Configurações",
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mode escuro",
                                style: Theme.of(context).textTheme.bodyLarge),
                            Switch(
                              trackOutlineColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.black12),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey,
                              value: provider.state.active,
                              onChanged: (value) {
                                setState(() {
                                  provider.state.toggle();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Audio dos jogos",
                                style: Theme.of(context).textTheme.bodyLarge),
                            Switch(
                              trackOutlineColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.black12),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.grey,
                              value: audioDosJogos,
                              onChanged: (value) {
                                setState(() {
                                  audioDosJogos = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.grey,
                        ),
                        height: 3,
                        width: double.infinity,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sobre",
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Versão: 1.0.0"),
                            Text("Site do projeto: "),
                            Text("www.mywallet.org")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
