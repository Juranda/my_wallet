import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/pages/aluno_cadastro_view.dart';
import 'package:my_wallet/pages/homepage_view.dart';
import 'package:my_wallet/pages/login_view.dart';
import 'package:my_wallet/pages/professor_cadastro_view.dart';
import 'package:my_wallet/styles.dart';

void main() {
  runApp(const App());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Wallet',
      theme: Styles.lightThemeData,
      darkTheme: Styles.darkThemeData,
      initialRoute: "/login",
      routes: <String, WidgetBuilder>{
        "/login": (context) => LoginView(),
        "/siginup&pessoa=aluno": (context) => AlunoCadastroView(),
        "/siginup&pessoa=professor": (context) => ProfessorCadastroView(),
        "/home": (context) => HomePageView(),
      },
    );
  }
}
