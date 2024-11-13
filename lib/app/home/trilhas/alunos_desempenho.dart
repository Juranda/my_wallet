import 'package:flutter/material.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:my_wallet/models/trilha/trilha.dart';
import 'package:my_wallet/models/turma.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

class AlunosDesempenho extends StatefulWidget {
  late Trilha trilha;
  late List<AlunoTrilhaRealiza> alunoTrilhaRealiza;
  late TurmaProvider _turmaProvider;
  final List<Aluno> alunos = [];

  AlunosDesempenho({super.key});

  @override
  State<AlunosDesempenho> createState() => _AlunosDesempenhoState();
}

class _AlunosDesempenhoState extends State<AlunosDesempenho> {
  @override
  void initState() async {
    widget._turmaProvider = Provider.of(context)<TurmaProvider>();
    widget.alunoTrilhaRealiza = await MyWallet.trailsService
        .getAllTrilhasDoAluno(widget.trilha.id, widget._turmaProvider.turma.id);

    for (var aluno in widget.alunoTrilhaRealiza) {
      widget.alunos.add(await MyWallet.userService.getAluno(aluno.idAluno, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        title: Text(widget.alunos[index].nome),
      );
    });
  }
}
