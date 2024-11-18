import 'package:flutter/foundation.dart';
import 'package:my_wallet/services/implementations/supabase/supabase_expenses_service.dart';
import 'package:my_wallet/services/implementations/supabase/supabase_trilha_service.dart';
import 'package:my_wallet/services/implementations/supabase/supabase_turma_service.dart';
import 'package:my_wallet/services/implementations/supabase/supabase_user_service.dart';
import 'package:my_wallet/services/atividade_service.dart';
import 'package:my_wallet/services/expenses_service.dart';
import 'package:my_wallet/services/trilha_service.dart';
import 'package:my_wallet/services/turma_service.dart';
import 'package:my_wallet/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyWallet {
  static final MyWallet instance = MyWallet._();
  static final TrilhaService trailsService = SupabaseTrilhaService();
  static final UserService userService = SupabaseUserService();
  static final ExpensesService expensesService = SupabaseExpensesService();
  static final TurmaService turmaService = SupabaseTurmaService();
  static final AtividadeService atividadeService = AtividadeService();
  static final NoticiasService noticiasService = StaticNoticiasService();

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
      debug: kDebugMode,
    );
    _initialized = true;
  }
}
