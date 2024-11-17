import 'package:flutter_test/flutter_test.dart';
import 'package:my_wallet/app/home/organizador_gastos/models/transaction.dart';
import 'package:my_wallet/services/mywallet.dart';

void main(){
  setUp((){MyWallet.instance.initialize();});
  test('testa inserir negoco fodase', (){
    MyWallet.expensesService.inserirTransacao(CreateTransaction(idUsuario: 1, idCategoria: 27, title: 'w', value: 123, date: DateTime.now()));
  });
}