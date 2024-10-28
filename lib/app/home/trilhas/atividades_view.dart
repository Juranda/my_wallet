import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/atividade_view.dart';
import 'package:my_wallet/app/home/trilhas/result_view.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/trilha_aluno_realiza.dart';

class AtividadesView extends StatefulWidget {
  const AtividadesView({super.key});

  @override
  State<AtividadesView> createState() => _AtividadesViewState();
}

class _AtividadesViewState extends State<AtividadesView> {
  late TrilhaAlunoRealiza aluno_trilha_realiza;
  late List<Atividade> atividades = [];
  final List<Widget> atividades_views = [];
  var selectedIndex = 0;


  final Map<int, int?> respostasSelecionadas = {};


  //final List<AtividadeAlunoRealiza> atividades = [];

  void ChangeSelectedIndex(int amount) {
    setState(() {
      selectedIndex = (selectedIndex + amount).clamp(0, atividades_views.length-1);
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

    //atividades_views.add(ResultView(atividades, ChangeSelectedIndex));
  }

  @override
  Widget build(BuildContext context) {
    this.aluno_trilha_realiza = ModalRoute.of(context)!.settings.arguments as TrilhaAlunoRealiza;
    if (atividades.isEmpty && atividades_views.isEmpty){

      for (var atv_aluno_realiza in aluno_trilha_realiza.atividades) {
        atividades.add(atv_aluno_realiza.atividade);
      }
      
      for (int i = 0; i < atividades.length; i++) {
        var key = UniqueKey();
        respostasSelecionadas.addAll({atividades[i].id: null});
        atividades_views.add(AtividadeView(atividade: atividades[i], alunoRealiza: aluno_trilha_realiza.atividades[i],key: key, getRespostaSelecionada: getRespostaSelecionada, setRespostaSelecionada: setRespostaSelecionada));
        
      }
      atividades_views.add(ResultView())
    }
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            atividades_views[selectedIndex],
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () => ChangeSelectedIndex(-1),
                      child: Text('Anterior')),
                  if (selectedIndex < atividades_views.length-1)
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
