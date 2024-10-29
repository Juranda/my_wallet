import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/atividade_view.dart';
import 'package:my_wallet/app/home/trilhas/result_view.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';

class AtividadesView extends StatefulWidget {
  const AtividadesView({super.key});

  @override
  State<AtividadesView> createState() => _AtividadesViewState();
}

class _AtividadesViewState extends State<AtividadesView> {
  late AlunoTrilhaRealiza alunoTrilhaRealiza;
  late List<Atividade> atividades = [];
  final List<Widget> atividadesViews = [];
  var atividadeExibida = 0;


  final Map<int, int?> respostasSelecionadas = {};


  //final List<AtividadeAlunoRealiza> atividades = [];

  void ChangeSelectedIndex(int quanto) {
    setState(() {
      atividadeExibida = (atividadeExibida + quanto).clamp(0, atividadesViews.length-1);
    });
  }

  int? getRespostaSelecionada(int atvId){
    return respostasSelecionadas[atvId];
  }
  void setRespostaSelecionada(int atvId, int value){
    respostasSelecionadas[atvId] = value;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.alunoTrilhaRealiza = ModalRoute.of(context)!.settings.arguments as AlunoTrilhaRealiza;
    if (atividades.isEmpty && atividadesViews.isEmpty){

      for (var atv_aluno_realiza in alunoTrilhaRealiza.atividades) {
        atividades.add(atv_aluno_realiza.atividade);
      }
      
      for (int i = 0; i < atividades.length; i++) {
        var key = UniqueKey();
        respostasSelecionadas.addAll({atividades[i].id: null});
        atividadesViews.add(AtividadeView(atividade: atividades[i], alunoRealiza: alunoTrilhaRealiza.atividades[i],key: key, getRespostaSelecionada: getRespostaSelecionada, setRespostaSelecionada: setRespostaSelecionada));
        
      }
      atividadesViews.add(ResultView());
    }
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            atividadesViews[atividadeExibida],
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () => ChangeSelectedIndex(-1),
                      child: Text('Anterior')),
                  if (atividadeExibida < atividadesViews.length-1)
                  ElevatedButton(
                      onPressed: () => ChangeSelectedIndex(1),
                      child: Text('Próxima'))
                  else
                  ElevatedButton(
                      onPressed: () => ChangeSelectedIndex(1),
                      child: Text('Próxima')),
                ],
              ),
            )
          ],
        ));
  }
}
