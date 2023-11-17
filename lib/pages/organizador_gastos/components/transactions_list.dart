import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/pages/organizador_gastos/models/transaction.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList(this._transactions);

  final List<Transaction> _transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: _transactions.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Não há nenhuma transação cadastrada!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 300,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.contain,
                  ),
                )
              ],
            )
          : Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tr = _transactions[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text('R\$${tr.value}'),
                          ),
                        ),
                      ),
                      title: Text(
                        tr.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        DateFormat('d MMM y', 'pt-br').format(tr.date),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
