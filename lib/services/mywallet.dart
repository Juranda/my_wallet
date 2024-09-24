import 'package:my_wallet/services/expenses_service.dart';
import 'package:my_wallet/services/trailsservice.dart';
import 'package:my_wallet/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyWallet {
  static final MyWallet instance = MyWallet._();
  static final TrailsService trailsService = TrailsService();
  static final UserService userService = UserService();
  static final ExpensesService expensesService = ExpensesService();

  MyWallet._();
  bool _initialized = false;

  Future<void> initialize(
      // String anonKey,
      // String url,
      ) async {
    assert(
      !instance._initialized,
      'This instance is already initialized',
    );
    await Supabase.initialize(
        url: "https://bierpaosxpulmlvgzbht.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJpZXJwYW9zeHB1bG1sdmd6Ymh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU5ODI1NTIsImV4cCI6MjAzMTU1ODU1Mn0.uxVn2A0Eo6lLAMt6o8i8RiodilGLKirfbrvK-clYhzI");
    _initialized = true;
  }
}
