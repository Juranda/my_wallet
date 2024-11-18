import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/alunos_desempenho.dart';
import 'package:my_wallet/app/home/trilhas/atividade_prof_view.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

class AtividadesProfView extends StatefulWidget {
  const AtividadesProfView({super.key});

  @override
  State<AtividadesProfView> createState() => _AtividadesProfViewState();
}

class _AtividadesProfViewState extends State<AtividadesProfView> {
  Trilha? trilha = null;
  List<Atividade>? atividadesTrilha = null;

  final List<Atividade> atividades = [];
  final List<Widget> atividadesViews = [];
  var atividadeExibida = 0;

  void changeSelectedIndex(int quanto) {
    setState(() {
      atividadeExibida =
          (atividadeExibida + quanto).clamp(0, atividadesViews.length - 1);
    });
  }

  void inicializarViews(Trilha trilha, List<Atividade> atvs) {
    atividades.clear();
    atividadesViews.clear();

    atividades.addAll(atvs);

    for (int i = 0; i < atividades.length; i++) {
      var key = UniqueKey();
      atividadesViews.add(AtividadeProfView(
          atividade: atividades[i],
          atualizarViewPrincipal: () => setState(() {}),
          key: key));
    }
  }

  Future<Map<String, dynamic>> getDados() async {
    TurmaProvider _turma_provider = Provider.of<TurmaProvider>(context);
    List<AlunoTrilhaRealiza> alunoTrilhaRealiza = await MyWallet.trailsService
        .getAllAlunoTrilhaRealiza(trilha!.id, _turma_provider.turma.id);
    List<Aluno> alunos = [];
    for (var trilhaRealiza in alunoTrilhaRealiza) {
      alunos
          .add(await MyWallet.userService.getAlunoPorId(trilhaRealiza.idAluno));
    }

    Map<String, dynamic> dados = {
      'alunoTrilhaRealiza': alunoTrilhaRealiza,
      'alunos': alunos
    };

    return dados;
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (trilha == null) {
      this.trilha = args['trilha'];
    }

    if (atividades.isEmpty && atividadesViews.isEmpty) {
      inicializarViews(trilha!, args['atividades']);
    }
    return FutureBuilder(
        future: getDados(),
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: Text(trilha!.nome),
                actions: [
                  IconButton(
                    onPressed: !snapshot.hasData
                        ? null
                        : () => Navigator.pushNamed(
                            context, Routes.ALUNOS_DESEMPENHO,
                            arguments: snapshot.data),
                    icon: Icon(Icons.people),
                  ),
                ],
              ),
              body: Builder(builder: (context) {
                if (snapshot.hasError) return Text(snapshot.error.toString());
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return Column(
                  children: [
                    Expanded(child: atividadesViews[atividadeExibida]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: atividadeExibida == 0
                                ? null
                                : () => changeSelectedIndex(-1),
                            child: Text('Anterior')),
                        if (atividadeExibida == atividadesViews.length - 1)
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Voltar'))
                        else
                          ElevatedButton(
                              onPressed: () => changeSelectedIndex(1),
                              child: Text('Próxima'))
                      ],
                    )
                  ],
                );
              }));
        });
  }
}
