import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/resultados_view.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

class AlunosDesempenho extends StatefulWidget {
  late List<AlunoTrilhaRealiza> alunoTrilhaRealiza;
  late List<Aluno> alunos;

  AlunosDesempenho({super.key});

  @override
  State<AlunosDesempenho> createState() => _AlunosDesempenhoState();
}

class _AlunosDesempenhoState extends State<AlunosDesempenho> {
  calcularAcertos(AlunoTrilhaRealiza trilhaRealiza) {
    if (trilhaRealiza.completadaEm == null) return "Não realizou";

    int acertos = 0;
    for (var atividade in trilhaRealiza.atividades) {
      if (atividade.acerto == true) {
        acertos++;
      }
    }
    return "${acertos}/${trilhaRealiza.atividades.length}";
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    widget.alunoTrilhaRealiza = args['alunoTrilhaRealiza'];
    widget.alunos = args['alunos'];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Desempenho da turma'),
      ),
      body: ListView.builder(
          itemCount: widget.alunoTrilhaRealiza.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(widget.alunos[index].nome),
                trailing:
                    Text(calcularAcertos(widget.alunoTrilhaRealiza[index])),
                onTap: widget.alunoTrilhaRealiza[index].completadaEm == null
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  appBar: AppBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    title: Text('Desempenho do aluno ' +
                                        widget.alunos[index].nome),
                                  ),
                                  body: ResultadosView(
                                      alunoTrilhaRealiza:
                                          widget.alunoTrilhaRealiza[index]),
                                ))));
          }),
    );
  }
}
