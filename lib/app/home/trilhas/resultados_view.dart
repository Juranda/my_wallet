import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/resultado_detalhes.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ResultadosView extends StatefulWidget {
  final AlunoTrilhaRealiza alunoTrilhaRealiza;

  const ResultadosView({required this.alunoTrilhaRealiza, super.key});

  @override
  State<ResultadosView> createState() => _ResultadosViewState();
}

class _ResultadosViewState extends State<ResultadosView> {
  calcularAcertos() {
    int acertos = 0;
    for (var atividade in widget.alunoTrilhaRealiza.atividades) {
      if (atividade.acerto == true) {
        acertos++;
      }
    }
    return "${acertos}/${widget.alunoTrilhaRealiza.atividades.length}";
  }
  bool exibindoDetalhes = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> resultados = [];
    List<Widget> detalhes = [];


    for (var atividade in widget.alunoTrilhaRealiza.atividades) {
      detalhes.add(ResultadoDetalhes(alunoAtividadeRealiza: atividade));
    }

    for (int i = 0; i < widget.alunoTrilhaRealiza.atividades.length; i++) {
      resultados.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Questão ${i + 1}: "),
          widget.alunoTrilhaRealiza.atividades[i].acerto == true
              ? Icon(Icons.check)
              : Icon(Icons.close)
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Resultados"),
              SizedBox(
                height: 50,
              ),
              ...resultados,
              SizedBox(
                height: 50,
              ),
              Text("Total: " + calcularAcertos()),
              ExpansionPanelList(
                expandedHeaderPadding: EdgeInsets.zero,
                elevation: 0,
                children: [
                  ExpansionPanel(
                    
                    backgroundColor: Theme.of(context).colorScheme.background,
                    headerBuilder: (context, isOpen) => Center(child: Text('Mostrar Detalhes'),),
                    body: Column(children: detalhes,),
                    isExpanded: exibindoDetalhes
                  ),
                ],
                expansionCallback: (i, isOpen)=>setState(() {
                  exibindoDetalhes = !exibindoDetalhes;
                })
              ),
            ],
          ),
        ),
      ),
    );
  }
}
