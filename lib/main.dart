import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/providers/settings_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // String annonKey = dotenv.get("ANNON_KEY");
  // String url = dotenv.get("URL");

  MyWallet.instance.initialize(
      // annonKey,
      // url,
      );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const App());
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
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TurmaProvider())
      ],
      builder: (context, child) {
        return SafeArea(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Wallet',
            theme: Provider.of<SettingsProvider>(context).themeData,
            initialRoute: Routes.LOGIN,
            routes: Routes.routes,
          ),
        );
      },
    );
  }
}
