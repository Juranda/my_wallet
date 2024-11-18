import 'package:flutter/material.dart';
import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

class ProfTrilhaItem extends StatefulWidget {
  final Trilha trilha;
  const ProfTrilhaItem(this.trilha, {super.key});

  @override
  State<ProfTrilhaItem> createState() => _ProfTrilhaItemState();
}

class _ProfTrilhaItemState extends State<ProfTrilhaItem> {
  late final TurmaProvider _turmaProvider;

  void abrirTrilha(context) async {
    Map<String, dynamic> arguments = {};
    arguments['trilha'] = widget.trilha;
    arguments['atividades'] =
        await MyWallet.atividadeService.getAtividadesDeTrilha(widget.trilha.id);

    Navigator.pushNamed(context, Routes.TRAILS_TRAIL_DETALHE_PROF,
        arguments: arguments);
  }

  @override
  void initState() {
    super.initState();
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
  }

  Future<bool> getTrilhaInfo() async {
    return await MyWallet.trailsService
        .trilhaJaLiberada(widget.trilha.id, _turmaProvider.turma.id);
  }

  void showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Liberar Trilha?"),
      content: Text(
          "Ao confirmar, essa Trilha será liberada para todos os alunos da turma!"),
      actions: [
        ElevatedButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text("Confirmar"),
          onPressed: () async {
            Navigator.pop(context);
            await MyWallet.trailsService
                .liberarTrilha(widget.trilha.id, _turmaProvider.turma.id);
            setState(() {});
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text('Trilha liberada!'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Ok'),
                  )
                ],
              ),
            );
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

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;
    return FutureBuilder(
        future: getTrilhaInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Text('Um erro ocorreu: ' + snapshot.error.toString());
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => abrirTrilha(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      child: Image.asset(
                        'assets/images/cartao_credito.png',
                        fit: BoxFit.contain,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.trilha.nome,
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (snapshot.data == true) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text('A trilha já foi liberada!'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Ok'),
                                  )
                                ],
                              ),
                            );
                          } else {
                            showAlertDialog(context);
                          }
                        },
                        icon: snapshot.data == true
                            ? Icon(Icons.check)
                            : Icon(Icons.lock)),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
