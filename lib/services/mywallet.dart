import 'package:my_wallet/services/implementations/supabase/supabase_expenses_service.dart';
import 'package:my_wallet/services/implementations/supabase/supabase_trails_service.dart';
import 'package:my_wallet/services/implementations/supabase/supabase_user_service.dart';
import 'package:my_wallet/services/expenses_service.dart';
import 'package:my_wallet/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyWallet {
  static final MyWallet instance = MyWallet._();
  static final SupabaseTrailsService trailsService = SupabaseTrailsService();
  static final UserService userService = SupabaseUserService();
  static final ExpensesService expensesService = SupabaseExpensesService();

  MyWallet._();
  bool _initialized = false;

  Future<void> initialize(
    String anonKey,
    String url,
  ) async {
    assert(
      !instance._initialized,
      'This instance is already initialized',
    );
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: false,
    );
    _initialized = true;
  }
}
