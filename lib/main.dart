import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:my_wallet/pages/account_settings/account_settings_view.dart';
import 'package:my_wallet/pages/account_settings/mudar_senha.dart';
import 'package:my_wallet/pages/cadastro/aluno_cadastro_view.dart';
import 'package:my_wallet/pages/app_settings_view.dart';
import 'package:my_wallet/pages/cadastro/deletar_cadastro_view.dart';
import 'package:my_wallet/pages/homepage_view.dart';
import 'package:my_wallet/pages/login/login_view.dart';
import 'package:my_wallet/pages/cadastro/professor_cadastro_view.dart';
import 'package:my_wallet/pages/realidade_aumentada/ar_view.dart';
import 'package:my_wallet/pages/trilhas/trails_view.dart';
import 'package:my_wallet/role_provider.dart';
import 'package:my_wallet/settings_provider.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => RoleProvider())
      ],
      builder: (context, child) {
        return SafeArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Wallet',
            theme: Provider.of<SettingsProvider>(context).themeData,
            initialRoute: "/login",
            routes: <String, WidgetBuilder>{
              "/login": (context) => LoginView(),
              "/siginup&pessoa=aluno": (context) => AlunoCadastroView(),
              "/siginup&pessoa=professor": (context) => ProfessorCadastroView(),
              "/home": (context) => HomePageView(),
              "/home/trails/trail": (context) => TrailView(),
              "/appSettings": (context) => AppSettingsView(),
              "/ar": (context) => ArView(),
              "/accountSettings": (context) => AccountSettingsView(),
              "/accountSettingsChangePassword": (context) =>
                  AccountChangePassword(),
              "/siginup/deletar":(context) => DeletarCadastroView(),
            },
          ),
        );
      },
    );
  }
}
