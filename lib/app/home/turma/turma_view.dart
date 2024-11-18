import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/turma/aluno_list_tile.dart';
import 'package:my_wallet/app/home/turma/turma_adiconar_aluno.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/users/funcao.dart';

class TurmaView extends StatefulWidget {
  TurmaView({super.key});

  @override
  State<TurmaView> createState() => _TurmaViewState();
}

class _TurmaViewState extends State<TurmaView> {
  List<AlunoListTile> alunos = [];

  late final Stream<List<Aluno>> _alunoStream;

  late UserProvider _roleProvider;
  late TurmaProvider _turmaProvider;

  void showRemoverAlunoDialog(BuildContext context, int alunoId) {
    AlertDialog alert = AlertDialog(
      title: Text("Confirmação"),
      content: Text("Remover aluno da turma?"),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            MyWallet.turmaService
                .removerAlunoDaTurma(alunoId, _turmaProvider.turma.id);
            Navigator.pop(context);
          },
          child: Text("Confirmar"),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _roleProvider = Provider.of<UserProvider>(context, listen: false);
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
    _alunoStream =
        MyWallet.turmaService.getAlunosStream(_turmaProvider.turma.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _alunoStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Text(
              'Um erro ocorreu, tente mais tarde ${snapshot.error.toString()}',
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          List<Aluno> alunos = snapshot.data!;
          return Column(
            children: [
              Container(
                height: 60,
                color: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Text(
                    'Turma ' +
                        (_roleProvider.eProfessor
                            ? _turmaProvider.turma.nome
                            : _roleProvider.eAluno
                                ? _roleProvider.aluno.nomeTurma
                                : ''),
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Alunos (${alunos.length})',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center),
                    if (_roleProvider.tipoUsuario == Funcao.Professor)
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Adicionar Aluno'),
                              content: AdicionarAluno(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_circle,
                          size: 40,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: ListView.builder(
                      itemCount: alunos.length,
                      itemBuilder: (context, index) {
                        final aluno = alunos[index];

                        return ListTile(
                          key: Key(aluno.id.toString()),
                          title: Text(
                            aluno.nome,
                          ),
                          trailing: !_roleProvider.eProfessor
                              ? null
                              : IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => showRemoverAlunoDialog(
                                      context, aluno.id)),
                        );
                      },
                    )),
              ),
            ],
          );
        });
  }
}
