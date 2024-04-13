import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/context-providers/DarkModeContextProvider.dart';
import 'package:my_wallet/pages/aluno_cadastro_view.dart';
import 'package:my_wallet/pages/homepage_view.dart';
import 'package:my_wallet/pages/login_view.dart';
import 'package:my_wallet/pages/professor_cadastro_view.dart';
import 'package:my_wallet/styles.dart';

import 'pages/settings.dart';

void main() {
  runApp(const App());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return DarkModeContextProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Wallet',
        theme: Styles.lightThemeData,
        darkTheme: true ? Styles.darkThemeData : Styles.lightThemeData,
        initialRoute: "/login",
        routes: <String, WidgetBuilder>{
          "/login": (context) => LoginView(),
          "/siginup&pessoa=aluno": (context) => AlunoCadastroView(),
          "/siginup&pessoa=professor": (context) => ProfessorCadastroView(),
          "/home": (context) => HomePageView(),
          "/settings": (context) => Settings(),
        },
      ),
    );
  }
}
