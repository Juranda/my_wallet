import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_wallet/app/home/organizador_gastos/components/transaction_form.dart';
import 'package:my_wallet/app/home/organizador_gastos/components/transactions_list.dart';
import 'package:my_wallet/app/home/organizador_gastos/models/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  Future<void> sumMoney(double money) async {
    final dinheiro = await Supabase.instance.client
        .from('aluno')
        .select('dinheiro')
        .eq('id_usuario', Supabase.instance.client.auth.currentUser!.id)
        .single();
    await Supabase.instance.client
        .from('aluno')
        .update({'dinheiro': (dinheiro['dinheiro'] + money)}).eq(
            'id_usuario', Supabase.instance.client.auth.currentUser!.id);
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  Future<void> insertTransaction(
      {required String title,
      required double value,
      required String data}) async {
    await Supabase.instance.client.from('gasto').insert({
      'valor': value,
      'titulo': title,
      'data': data,
      'id_usuario': Supabase.instance.client.auth.currentUser!.id
    });
    sumMoney(-value);
  }

  void _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(onSubmit: insertTransaction);
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
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: Supabase.instance.client
                      .from('aluno')
                      .stream(primaryKey: ['id'])
                      .eq('id_usuario',
                          Supabase.instance.client.auth.currentUser!.id)
                      .limit(1),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.hasError ||
                        snapshot.data!.isEmpty)
                      return CircularProgressIndicator(
                        color: Colors.white,
                      );
                    return Text(
                      "R\$" +
                          (snapshot.data![0]['dinheiro'] as int)
                              .toDouble()
                              .toStringAsFixed(2)
                              .toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    );
                  },
                )),
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
