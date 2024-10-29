import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_wallet/app/home/organizador_gastos/components/transaction_form.dart';
import 'package:my_wallet/app/home/organizador_gastos/components/transactions_list.dart';
import 'package:my_wallet/models/expenses/conta.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/expenses_service.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class Investiments extends StatefulWidget {
  const Investiments({super.key});

  @override
  State<Investiments> createState() => _InvestimentsState();
}

class _InvestimentsState extends State<Investiments> {
  final uuid = Uuid();
  late final UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt-br');
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  Future<void> sumMoney(double money) async {
    final dinheiro = await Supabase.instance.client
        .from('aluno')
        .select('dinheiro')
        .eq(
          'idUsuario',
          Supabase.instance.client.auth.currentUser!.id,
        )
        .single();
    await Supabase.instance.client
        .from('aluno')
        .update({'dinheiro': (dinheiro['dinheiro'] + money)}).eq(
      'idUsuario',
      Supabase.instance.client.auth.currentUser!.id,
    );
  }

  Future<void> insertTransaction(
      {required String title,
      required double value,
      required String data}) async {
    await Supabase.instance.client.from('gasto').insert({
      'valor': value,
      'titulo': title,
      'data': data,
      'idUsuario': Supabase.instance.client.auth.currentUser!.id
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return StreamBuilder<Conta>(
          stream: MyWallet.expensesService.streamConta(
            _userProvider.usuario.idInstituicaoEnsino,
            _userProvider.aluno.id,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                  'Um erro ocorreu, tente mais tarde ${snapshot.error.toString()}');
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            Conta conta = snapshot.data!;

            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "R\$" + conta.dinheiro.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxWidth * 0.05,
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
                    ),
                  ],
                ),
                TransactionsList(
                  transacoes: conta.transacoes,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
