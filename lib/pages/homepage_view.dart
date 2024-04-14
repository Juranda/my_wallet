import 'package:flutter/material.dart';
import 'package:my_wallet/pages/investiments.dart';
import 'package:my_wallet/pages/lobby.dart';
import 'package:my_wallet/pages/realidade_aumentada/ar_view.dart';
import 'package:my_wallet/pages/trails_view.dart';
import 'package:my_wallet/pages/turmas_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: _selectedPageIndex == 0
                  ? BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Color.fromRGBO(34, 95, 8, 1)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    )
                  : BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                      onPressed: () => setState(
                        () {
                          Navigator.pushNamed(context, '/appSettings');
                        },
                      ),
                      icon: Icon(
                        Icons.settings,
                        size: 40,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            [
              Lobby(),
              TrailsView(),
              Investiments(),
              TurmasView(),
              ArView()
            ][_selectedPageIndex],
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: (value) => setState(
          () => _selectedPageIndex = value,
        ),
        destinations: [
          NavigationDestination(icon: Icon(Icons.abc), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Trilhas'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Investimentos'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Turma'),
          NavigationDestination(icon: Icon(Icons.abc), label: 'Ar'),
        ],
      ),
    );
  }
}
