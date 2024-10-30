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

  void FinalizarAtividade() {}

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Finalizar?"),
      content:
          Text("Finalizar atividade? As respostas não poderão ser alteradas."),
      actions: [
        ElevatedButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text("Continuar"),
          onPressed: () {
            Navigator.pop(context);
            ChangeSelectedIndex(1);
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void ChangeSelectedIndex(int quanto) {
    setState(() {
      atividadeExibida =
          (atividadeExibida + quanto).clamp(0, atividadesViews.length - 1);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.alunoTrilhaRealiza =
        ModalRoute.of(context)!.settings.arguments as AlunoTrilhaRealiza;
    if (atividades.isEmpty && atividadesViews.isEmpty) {
      for (var atv_aluno_realiza in alunoTrilhaRealiza.atividades) {
        atividades.add(atv_aluno_realiza.atividade);
      }

      for (int i = 0; i < atividades.length; i++) {
        var key = UniqueKey();
        atividadesViews.add(AtividadeView(
            atividade: atividades[i],
            alunoRealiza: alunoTrilhaRealiza.atividades[i],
            atualizarViewPrincipal: () => setState(() {}),
            key: key));
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
                  if (atividadeExibida == atividadesViews.length - 1)
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Voltar'))
                  else if (atividadeExibida == atividadesViews.length - 2)
                    ElevatedButton(
                        onPressed: alunoTrilhaRealiza
                                    .atividades[atividadeExibida]
                                    .opcaoSelecionada ==
                                -1
                            ? null
                            : () => showAlertDialog(context),
                        child: Text('Finalizar'))
                  else
                    ElevatedButton(
                        onPressed: alunoTrilhaRealiza
                                    .atividades[atividadeExibida].feito ==
                                false
                            ? null
                            : () => ChangeSelectedIndex(1),
                        child: Text('Próxima'))
                ],
              ),
            )
          ],
        ));
  }
}
