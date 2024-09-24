import 'package:flutter/material.dart';
import 'package:my_wallet/models/expenses/transacao.dart';

class TransactionsList extends StatelessWidget {
  final List<Transacao> transacoes;

  const TransactionsList({super.key, required this.transacoes});

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
                    subtitle: Text(transacao.realizadaEm.toLocal().toString()),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            'R\$${transacao.valor}',
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
