import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/pages/organizador_gastos/models/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList(this._transactions);

  final List<Transaction> _transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client.from('gasto').stream(primaryKey: [
              'id'
            ]).eq('id_usuario', Supabase.instance.client.auth.currentUser!.id),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.hasError ||
                  snapshot.data!.isEmpty) return Container();

              final gastos = snapshot.data!;
              return ListView.builder(
                  itemCount: gastos.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 5,
                      ),
                      child: ListTile(
                        title: Text(
                          gastos[index]['titulo'],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(gastos[index]['data']),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 30,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: FittedBox(
                              child: Text('R\$${gastos[index]['valor']}'),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}


// Container(
//               height: MediaQuery.of(context).size.height / 2,
//               child: ListView.builder(
//                 itemCount: _transactions.length,
//                 itemBuilder: (context, index) {
//                   final tr = _transactions[index];
//                   return Card(
//                     elevation: 5,
//                     margin: EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 5,
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         radius: 30,
//                         child: Padding(
//                           padding: const EdgeInsets.all(6),
//                           child: FittedBox(
//                             child: Text('R\$${tr.value}'),
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         tr.title,
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                       subtitle: Text(
//                         DateFormat('d MMM y', 'pt-br').format(tr.date),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),