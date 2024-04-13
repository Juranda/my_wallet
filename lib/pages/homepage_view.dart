import 'package:flutter/material.dart';
import 'package:my_wallet/pages/investiments.dart';
import 'package:my_wallet/pages/lobby.dart';
import 'package:my_wallet/pages/trails_view.dart';
import 'package:my_wallet/pages/turmas_view.dart';
import 'package:my_wallet/webviewexample.dart';

import 'my_wallet_app_bar.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyWalletAppBar(),
            [
              Lobby(),
              TrailsView(),
              Investiments(),
              TurmasView(),
              WebViewExample(),
            ][selectedPageIndex],
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (value) => setState(() {
          selectedPageIndex = value;
        }),
        destinations: [
          NavigationDestination(icon: Icon(Icons.abc), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Trilhas'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Investimentos'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Turma'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Ar')
        ],
      ),
    );
  }
}
