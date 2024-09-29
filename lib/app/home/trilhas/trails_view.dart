import 'package:flutter/material.dart';
import 'package:my_wallet/models/users/role.dart';
import 'package:my_wallet/providers/turma_provider.dart';
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
  late final UserProvider _userProvider;
  late final TurmaProvider _turmaProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
  }

  

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final idInstituicaoEnsino = _userProvider.usuario.id_instituicao_ensino;
    
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
          //se é professor, mostre todas as trilhas
          //se for aluno, mostre só as da turma (fetch trilhas)
        if(_userProvider.eAluno)
        FutureBuilder(
          future: MyWallet.trailsService.getAllTrilhasDoAluno(_userProvider.aluno.id_instituicao_ensino, _userProvider.aluno.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AlertDialog(
                title: const Text("Um erro ocorreuAqui"),
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
                          trilhas[index].trilha
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        )
        else FutureBuilder(
          future: MyWallet.trailsService.getAllTrilhasEscolaridade(_turmaProvider.turma.escolaridadeId), 
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
                          trilhas[index]
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          })
      ],
    );
  }
}
