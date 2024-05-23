import 'package:flutter/material.dart';
import 'package:my_wallet/pages/organizador_gastos/investiments.dart';
import 'package:my_wallet/pages/home/home.dart';
import 'package:my_wallet/pages/realidade_aumentada/ar_view.dart';
import 'package:my_wallet/pages/trilhas/trails_view.dart';
import 'package:my_wallet/pages/turma/turmas_view.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'account_settings/models/role.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);

    final List<Widget> navigationBarDestinations = [
      NavigationDestination(icon: Icon(Icons.abc), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.abc), label: 'Trilhas'),
      NavigationDestination(icon: Icon(Icons.abc), label: 'Turma'),
      NavigationDestination(icon: Icon(Icons.abc), label: 'AR'),
    ];
    final List<Widget> destinations = [
      Home(),
      TrailsView(),
      TurmasView(),
      ArView()
    ];

    if (_userProvider.role == Role.aluno) {
      navigationBarDestinations.insert(
          2, NavigationDestination(icon: Icon(Icons.abc), label: 'Gastos'));
      destinations.insert(2, Investiments());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          Container(
            decoration: _selectedPageIndex == 0
                ? BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Color.fromRGBO(34, 95, 8, 1)
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
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
            height: MediaQuery.of(context).size.height - 180,
            child: destinations[_selectedPageIndex],
          ),
        ],
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
                spreadRadius: 10)
          ]),
    );
  }
}
