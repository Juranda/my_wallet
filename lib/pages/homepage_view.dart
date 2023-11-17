import 'package:flutter/material.dart';
import 'package:my_wallet/pages/investiments.dart';
import 'package:my_wallet/pages/lobby.dart';
import 'package:my_wallet/pages/trails_view.dart';

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
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
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
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ),
            [
              Lobby(),
              TrailsView(),
              Investiments(),
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
        ],
      ),
    );
  }
}
