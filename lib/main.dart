import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/pages/cadastro_view.dart';
import 'package:my_wallet/pages/homepage_view.dart';
import 'package:my_wallet/pages/login_view.dart';
import 'package:my_wallet/styles.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const App());
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
        "/siginup": (context) => CadastroView(),
        "/home": (context) => HomePageView(),
      },
    );
  }
}
