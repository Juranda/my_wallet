import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/atividade_aluno_view.dart';
import 'package:my_wallet/app/home/trilhas/resultados_view.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:my_wallet/services/mywallet.dart';

class AtividadesAlunoView extends StatefulWidget {
  const AtividadesAlunoView({super.key});

  @override
  State<AtividadesAlunoView> createState() => _AtividadesAlunoViewState();
}

class _AtividadesAlunoViewState extends State<AtividadesAlunoView> {
  AlunoTrilhaRealiza? alunoTrilhaRealiza;
  final List<Atividade> atividades = [];
  final List<Widget> atividadesViews = [];
  var atividadeExibida = 0;

  bool respostasBloqueadas = false;

  void showAlertDialog(BuildContext context) {
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
          onPressed: () async {
            Navigator.pop(context);
            alunoTrilhaRealiza = await MyWallet.trailsService
                .finalizarTrilha(alunoTrilhaRealiza!);
            inicializarViews(alunoTrilhaRealiza!);
            changeSelectedIndex(1);
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

  void changeSelectedIndex(int quanto) {
    setState(() {
      atividadeExibida =
          (atividadeExibida + quanto).clamp(0, atividadesViews.length - 1);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void inicializarViews(AlunoTrilhaRealiza alunoTrilhaRealiza) {
    atividades.clear();
    atividadesViews.clear();
    for (var atv_aluno_realiza in alunoTrilhaRealiza.atividades) {
      atividades.add(atv_aluno_realiza.atividade);
    }
    respostasBloqueadas = alunoTrilhaRealiza.completadaEm != null;

    for (int i = 0; i < atividades.length; i++) {
      var key = UniqueKey();
      atividadesViews.add(AtividadeAlunoView(
          atividade: atividades[i],
          alunoRealiza: alunoTrilhaRealiza.atividades[i],
          atualizarViewPrincipal: () => setState(() {}),
          respostasBloqueadas: respostasBloqueadas,
          key: key));
    }
    atividadesViews.add(ResultadosView(
      alunoTrilhaRealiza: alunoTrilhaRealiza,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (alunoTrilhaRealiza == null) {
      this.alunoTrilhaRealiza =
          ModalRoute.of(context)!.settings.arguments as AlunoTrilhaRealiza;
    }

    if (atividades.isEmpty && atividadesViews.isEmpty) {
      inicializarViews(alunoTrilhaRealiza!);
    }
    return Scaffold(
        appBar: AppBar(title: Text(alunoTrilhaRealiza!.trilha.nome)),
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
                else if (atividadeExibida == atividadesViews.length - 2 &&
                    alunoTrilhaRealiza!.completadaEm == null)
                  ElevatedButton(
                      onPressed: alunoTrilhaRealiza!
                                  .atividades[atividadeExibida].feito ==
                              false
                          ? null
                          : () => showAlertDialog(context),
                      child: Text('Finalizar'))
                else if (atividadeExibida == atividadesViews.length - 2 &&
                    alunoTrilhaRealiza!.completadaEm != null)
                  ElevatedButton(
                      onPressed: alunoTrilhaRealiza!
                                  .atividades[atividadeExibida].feito ==
                              false
                          ? null
                          : () => changeSelectedIndex(1),
                      child: Text('Resultados'))
                else
                  ElevatedButton(
                      onPressed: alunoTrilhaRealiza!
                                  .atividades[atividadeExibida].feito ==
                              false
                          ? null
                          : () => changeSelectedIndex(1),
                      child: Text('Próxima'))
              ],
            )
          ],
        ));
  }
}
