import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/turma/aluno_list_tile.dart';
import 'package:my_wallet/app/home/turma/turma_adiconar_aluno.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/role.dart';

class TurmasView extends StatefulWidget {
  TurmasView({super.key});

  @override
  State<TurmasView> createState() => _TurmasViewState();
}

class _TurmasViewState extends State<TurmasView> {
  List<AlunoListTile> alunos = [];

  late final Stream<List<Map<String, dynamic>>> _alunoStream;

  late UserProvider _roleProvider;

  @override
  void initState() {
    super.initState();
    _roleProvider = Provider.of<UserProvider>(context, listen: false);
    _alunoStream = Supabase.instance.client.from('aluno').stream(
        primaryKey: ['id']).eq('id_turma', _roleProvider.aluno.id_turma);
  }

  Future<void> removerAlunoDaTurma(int id) async {
    await Supabase.instance.client
        .from('aluno')
        .update({'id_turma': null}).eq('id', id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          color: Theme.of(context).colorScheme.primary,
          child: Center(
            child: Text(
              'Turma ' + _roleProvider.aluno.nome_turma,
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
              StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _alunoStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Alunos (0)',
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center);
                    }

                    return Text('Alunos (${snapshot.data!.length})',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center);
                  }),
              if (_roleProvider.tipoUsuario == Role.Professor)
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
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _alunoStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final alunosData = snapshot.data!;

                if (alunosData.isEmpty) {
                  return ListView();
                }

                return ListView.builder(
                  itemCount: alunosData.length,
                  itemBuilder: (context, index) {
                    final aluno = alunosData[index];
                    return ListTile(
                      key: Key(aluno['id_usuario']),
                      title: Text(
                        aluno['nome'],
                      ),
                      trailing: _roleProvider.tipoUsuario == Role.Professor
                          ? IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Remover Aluno da turma?"),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          removerAlunoDaTurma(
                                            aluno['id'],
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: Text("Confirmar"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
