import 'package:my_wallet/app/home/organizador_gastos/models/transaction.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    MyWallet.instance.initialize();
  });

  test('expense_service_should_create_transaction', () async {
    var data = DateTime(2024, 10, 12);

    final createTransaction = CreateTransaction(
      idUsuario: 1,
      idCategoria: 1,
      date: data,
      title: '1',
      value: 20,
    );

    await MyWallet.expensesService.inserirTransacao(createTransaction);
  });
}
