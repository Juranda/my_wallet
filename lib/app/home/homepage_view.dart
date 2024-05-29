import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/organizador_gastos/investiments.dart';
import 'package:my_wallet/app/home/lobby/lobby.dart';
import 'package:my_wallet/app/home/realidade_aumentada/ar_view.dart';
import 'package:my_wallet/app/home/trilhas/trails_view.dart';
import 'package:my_wallet/app/home/turma/turmas_view.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/role.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedPageIndex = 0;
  late final UserProvider _userProvider;
  final List<Widget> navigationBarDestinations = [
    NavigationDestination(icon: Icon(Icons.abc), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.abc), label: 'Trilhas'),
    NavigationDestination(icon: Icon(Icons.abc), label: 'Turma'),
    NavigationDestination(icon: Icon(Icons.abc), label: 'AR'),
  ];

  final List<Widget> destinations = [
    Lobby(),
    TrailsView(),
    TurmasView(),
    ArView()
  ];

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_userProvider.role == Role.aluno) {
      navigationBarDestinations.insert(
        2,
        NavigationDestination(icon: Icon(Icons.abc), label: 'Gastos'),
      );
      destinations.insert(2, Investiments());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.12,
              decoration: _selectedPageIndex == 0
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Color.fromRGBO(34, 95, 8, 1)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    )
                  : BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            Routes.ACCOUNT_SETTINGS,
                          ),
                          icon: Icon(
                            Icons.account_circle,
                            size: 40,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Seja bem-vindo ${_userProvider.nome}!'),
                            switch (_userProvider.role) {
                              Role.professor => Text('Professor'),
                              Role.aluno =>
                                Text('Turma ' + (_userProvider.turma)),
                              Role.moderador => Text('ADMINISTRADOR'),
                            }
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => setState(
                        () {
                          Navigator.pushNamed(
                            context,
                            Routes.APP_SETTINGS,
                          );
                        },
                      ),
                      icon: Icon(
                        Icons.settings,
                        size: 40,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: constraints.maxHeight * 0.88,
              child: destinations[_selectedPageIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: (value) => setState(
          () => _selectedPageIndex = value,
        ),
        destinations: navigationBarDestinations,
      ),
    );
  }

  Widget _navBar() {
    return Container(
      height: 65,
      margin: EdgeInsets.only(right: 24, left: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 10,
          )
        ],
      ),
    );
  }
}

class BottomNavigationBar extends StatefulWidget {
  final List<int> destinations;

  const BottomNavigationBar({
    super.key,
    required this.destinations,
  });

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
