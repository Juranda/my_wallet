import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/models/expenses/transacao.dart';

class TransactionsList extends StatelessWidget {
  final List<Transacao> transacoes;

  TransactionsList({super.key, required this.transacoes});

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy - HH:mm:ss');
  final NumberFormat numberFormat = NumberFormat.currency();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: 300,
            child: ListView.builder(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                Transacao transacao = transacoes[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    title: Text(
                      transacao.nome,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      dateFormat.format(transacao.realizadaEm),
                    ),
                    trailing: Text(transacao.categoria.nome),
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      height: 40,
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            'R\$${transacao.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
