import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_wallet/pages/organizador_gastos/components/transaction_form.dart';
import 'package:my_wallet/pages/organizador_gastos/components/transactions_list.dart';
import 'package:my_wallet/pages/organizador_gastos/models/transaction.dart';
import 'package:uuid/uuid.dart';

class Investiments extends StatefulWidget {
  const Investiments({super.key});

  @override
  State<Investiments> createState() => _InvestimentsState();
}

class _InvestimentsState extends State<Investiments> {
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

  void _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(onSubmit: _addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'R\$ 400,00',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                ),
                child: TextButton(
                  onPressed: () => _openTransactionFormModal(context),
                  child: Text(
                    'Adicionar transação',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        TransactionsList(_transactions)
      ],
    );
  }
}
