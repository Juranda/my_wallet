import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/providers/settings_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  await dotenv.load(
      fileName: 'assets/env/${kReleaseMode ? '.prod' : '.dev'}.env');
  String annonKey = dotenv.get("ANNON_KEY");
  String url = dotenv.get("SUPABASE_URL");

  MyWallet.instance.initialize(
    annonKey,
    url,
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
        ChangeNotifierProvider(create: (context) => UserProvider())
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
