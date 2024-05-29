import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/app/home/organizador_gastos/models/transaction.dart';

import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;
  const Chart(this._recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return (List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(
          Duration(days: index),
        );

        double totalSum = 0.0;

        for (var transaction in _recentTransactions) {
          if (transaction.date.day == weekDay.day &&
              transaction.date.month == weekDay.month &&
              transaction.date.year == weekDay.year) {
            totalSum += transaction.value;
          }
        }

        return {
          'day': DateFormat.E('pt-br').format(weekDay),
          'value': totalSum,
        };
      },
    )).reversed.toList();
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactions;

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'].toString(),
                total: tr['value'] as double,
                percentage: (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
