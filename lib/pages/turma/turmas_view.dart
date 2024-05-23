import 'package:flutter/material.dart';
import 'package:my_wallet/components/aluno_list_tile.dart';
import 'package:my_wallet/pages/turma/turma_adiconar_aluno.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../account_settings/models/role.dart';

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
    _alunoStream = Supabase.instance.client
        .from('aluno')
        .stream(primaryKey: ['id']).eq('id_turma', _roleProvider.id_turma);
  }

  Future<void> removerAlunoDaTurma(int id) async {
    await Supabase.instance.client
        .from('aluno')
        .update({'id_turma': null}).eq('id', 1);
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
              'Turma ' + _roleProvider.turma,
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Alunos (${alunos.length})',
                  style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
              if (_roleProvider.role == Role.professor)
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
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                      trailing: _roleProvider.role == Role.professor
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
