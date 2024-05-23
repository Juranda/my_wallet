import 'package:flutter/material.dart';
import 'package:my_wallet/pages/organizador_gastos/models/transaction.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'components/transactions_list.dart';

class OrganizadorGastosOriginal extends StatefulWidget {
  @override
  State<OrganizadorGastosOriginal> createState() => _OrganizadorGastos();
}

class _OrganizadorGastos extends State<OrganizadorGastosOriginal> {
  final uuid = Uuid();

  final _transactions = <Transaction>[];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt-br');
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: uuid.v8(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  // void _openTransactionFormModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (_) {
  //       return TransactionForm(onSubmit: _addTransaction);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TransactionsList(_transactions),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
