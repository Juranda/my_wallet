import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/organizador_gastos/components/transaction_form.dart';
import 'package:my_wallet/app/home/organizador_gastos/components/transactions_list.dart';
import 'package:my_wallet/models/expenses/categoria.dart';
import 'package:my_wallet/models/expenses/conta.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';
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
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  // Future<void> sumMoney(double money) async {
  //   final dinheiro = await Supabase.instance.client
  //       .from('aluno')
  //       .select('dinheiro')
  //       .eq(
  //         'id_usuario',
  //         Supabase.instance.client.auth.currentUser!.id,
  //       )
  //       .single();
  //   await Supabase.instance.client
  //       .from('aluno')
  //       .update({'dinheiro': (dinheiro['dinheiro'] + money)}).eq(
  //     'id_usuario',
  //     Supabase.instance.client.auth.currentUser!.id,
  //   );
  // }

  // Future<void> insertTransaction({
  //   required int idUsuario,
  //   required int idCategoria,
  //   required String title,
  //   required double value,
  //   required DateTime data,
  // }) async {
  //   // await Supabase.instance.client.from('gasto').insert({
  //   //   'valor': value,
  //   //   'titulo': title,
  //   //   'data': data,
  //   //   'id_usuario': Supabase.instance.client.auth.currentUser!.id
  //   // });
  //   //sumMoney(-value);

  //   var transacao = CreateTransaction(
  //     idUsuario: idUsuario,
  //     idCategoria: idCategoria,
  //     date: data,
  //     title: title,
  //     value: value,
  //   );

  //   MyWallet.expensesService.inserirTransacao(transacao);
  // }

  @override
  Widget build(BuildContext context) {
    if (_userProvider.eAluno)
      return AlunoGastosView();
    else
      return ProfessorGastosView();
  }
}

class ProfessorGastosView extends StatefulWidget {
  const ProfessorGastosView({super.key});

  @override
  State<ProfessorGastosView> createState() => _ProfessorGastosViewState();
}

class _ProfessorGastosViewState extends State<ProfessorGastosView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Center(
        child: const Text('Relatorio de alunos'),
      ),
    );
  }
}

class AlunoGastosView extends StatefulWidget {
  const AlunoGastosView({super.key});

  @override
  State<AlunoGastosView> createState() => _AlunoGastosViewState();
}

class _AlunoGastosViewState extends State<AlunoGastosView> {
  void _openTransactionFormModal(BuildContext context, int userId) async {
    List<Categoria> categorias =
        await MyWallet.expensesService.getCategoriasUsuario(userId);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(
          categorias: categorias,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = Provider.of(context);
    return LayoutBuilder(builder: (context, constraints) {
      return StreamBuilder<Conta>(
        stream: MyWallet.expensesService.getTransacoesStream(
          idInstituicao: _userProvider.usuario.idInstituicaoEnsino,
          idAluno: _userProvider.aluno.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Text(
              'Um erro ocorreu, tente mais tarde ${snapshot.error.toString()}',
            );
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
                      "R\$" +
                          conta.dinheiro
                              .toStringAsFixed(2)
                              .replaceAll('.', ','),
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
                      onPressed: () => _openTransactionFormModal(
                          context, _userProvider.usuario.idUsuario),
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
    });
  }
}
