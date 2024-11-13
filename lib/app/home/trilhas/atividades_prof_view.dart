import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/alunos_desempenho.dart';
import 'package:my_wallet/app/home/trilhas/atividade_prof_view.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/routes.dart';

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

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    

    if (trilha == null) {
      this.trilha = args['trilha'];
    }

    if (atividades.isEmpty && atividadesViews.isEmpty) {
      inicializarViews(trilha!, args['atividades']);
    }
    return Scaffold(
        appBar: AppBar(title: Text(trilha!.nome), actions: [FloatingActionButton(
          onPressed: ()=>Navigator.pushNamed(context, Routes.ALUNOS_DESEMPENHO),
          child: Text('texto'),
          ),],),
        body: Column(
          children: [
            Expanded(child: atividadesViews[atividadeExibida]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () => changeSelectedIndex(-1),
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
        ));
  }
}
