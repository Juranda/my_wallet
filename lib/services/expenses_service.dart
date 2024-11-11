import 'package:my_wallet/app/home/organizador_gastos/models/transaction.dart';
import 'package:my_wallet/models/expenses/categoria.dart';
import 'package:my_wallet/models/expenses/conta.dart';

abstract class ExpensesService {
  Stream<Conta> getTransacoesStream({
    required int idInstituicao,
    required int idAluno,
    int limit = 10,
  });

  Future<Conta> getContaAluno(int idInstituicao, int idAluno);
  Future<void> inserirTransacao(CreateTransaction transacao);
  Future<List<Categoria>> getCategoriasUsuario(int idAluno);
}
