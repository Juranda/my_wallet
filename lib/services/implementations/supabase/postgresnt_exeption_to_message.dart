import 'package:my_wallet/services/exceptions/userexceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostgrestToUserException {
  static Exception fromPostgrest(PostgrestException exception) {
    switch (exception.code) {
      case '23505': // Unique contraint violado
        return RegisterUserException(
          'O campo único ${exception.hint} já existe na tabela',
        );
    }

    throw UnimplementedError('Codigo não tratado');
  }
}
