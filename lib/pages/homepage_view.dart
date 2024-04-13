import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_wallet/pages/app_settings_view.dart';
import 'package:my_wallet/pages/investiments.dart';
import 'package:my_wallet/pages/lobby.dart';
import 'package:my_wallet/pages/trails_view.dart';
import 'package:my_wallet/pages/turmas_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int selectedPageIndex = 0;
  int _currentPageView = 0;
  set currentPageView(int value) {
    _currentPageView = value;
    if (value < 3) selectedPageIndex = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: selectedPageIndex == 0
                  ? BoxDecoration(
                      gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Color.fromRGBO(34, 95, 8, 1)
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
                  : BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: ()=>Navigator.pushNamed(context, "/accountSettings"),
                          icon: Icon(
                            Icons.account_circle,
                            size: 40,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Seja bem-vinde Rodolfo!'),
                            Text('Turma 701'),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () => setState(() {
                              currentPageView = 4;
                            }),
                        icon: Icon(Icons.settings,
                            size: 40,
                            color: Theme.of(context).colorScheme.secondary))
                  ],
                ),
              ),
            ),
            [
              Lobby(),
              TrailsView(),
              Investiments(),
              TurmasView(),
              AppSettingsView()
            ][_currentPageView],
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (value) => setState(() {
          currentPageView = value;
        }),
        destinations: [
          NavigationDestination(icon: Icon(Icons.abc), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Trilhas'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Investimentos'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Turma'),
        ],
      ),
    );
  }
}
