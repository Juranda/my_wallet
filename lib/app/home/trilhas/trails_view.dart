import 'package:flutter/material.dart';
import 'package:my_wallet/models/users/role.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'trail_item.dart';

class TrailsView extends StatefulWidget {
  const TrailsView({super.key});

  @override
  State<TrailsView> createState() => _TrailsViewState();
}

class _TrailsViewState extends State<TrailsView> {
  late Future<List<Map<String, dynamic>>> getTrilhas;
  late final UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  Future<bool> trilhaJaLiberada(int trilhaID) async {
    final response = await Supabase.instance.client
        .from('trilha_turma')
        .select()
        .eq('id_trilha', trilhaID)
        .eq('id_turma', _userProvider.aluno.id_turma);

    return response.isNotEmpty;
  }

  Future<void> liberarTrilha(int trilhaID) async {
    if (await trilhaJaLiberada(trilhaID)) return;

    await Supabase.instance.client.from('trilha_turma').insert(
        {'id_turma': _userProvider.aluno.id_turma, 'id_trilha': trilhaID});

    //pra cada aluno da turma, criar a relação atividade-aluno de todas as atividades dessa trilha
    final alunos = await Supabase.instance.client
        .from('aluno')
        .select()
        .eq('id_turma', _userProvider.aluno.id_turma);
    final atividades = await Supabase.instance.client
        .from('atividade')
        .select()
        .eq('id_trilha', trilhaID);
    for (Map<String, dynamic> aluno in alunos) {
      for (Map<String, dynamic> atividade in atividades) {
        await Supabase.instance.client.from('aluno_atividade').insert({
          'liberada': atividades[0] == atividade,
          'completada': false,
          'id_aluno': aluno['id'],
          'id_atividade': atividade['id']
        });
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final idInstituicaoEnsino = _userProvider.usuario.id_instituicao_ensino;
    final idTurma;
    if (_userProvider.eAluno) idTurma = _userProvider.aluno.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _userProvider.tipoUsuario == Role.Aluno
                  ? "Trilhas Liberadas"
                  : "Liberar Trilhas",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
        FutureBuilder(
          //se é professor, mostre todas as trilhas
          //se for aluno, mostre só as da turma (fetch trilhas)
          future: _userProvider.eAluno
              ? MyWallet.trailsService.getAllTrilhasDoAluno(
                  idInstituicaoEnsino, _userProvider.aluno.id)
              : MyWallet.trailsService.getAllTrilhas(
                  idInstituicaoEnsino,
                ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AlertDialog(
                title: const Text("Um erro ocorreu"),
                content: Text("Erro ${snapshot.error}"),
              );
            }

            if (!snapshot.hasData) {
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            } else {
              final trilhas = snapshot.data;
              if (trilhas == null || trilhas.isEmpty) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Nenhuma trilha disponível',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                );
              }
              return Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: constraints.maxHeight,
                      color: Theme.of(context).colorScheme.background,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                          indent: 20,
                          endIndent: 20,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => TrailItem(
                          trilhas[index],
                          liberarTrilha,
                          trilhaJaLiberada,
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
