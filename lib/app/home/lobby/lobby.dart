import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/lobby/lobby_info_card.dart';
import 'package:my_wallet/app/home/lobby/stateful_section.dart';
import 'package:my_wallet/app/home/lobby/stateless_section.dart';
import 'package:my_wallet/app/home/lobby/lobby_noticia_card.dart';
import 'package:my_wallet/app/home/lobby/trail_lobby_card.dart';
import 'package:my_wallet/models/noticia.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  late TurmaProvider _turmaProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: constraints.maxHeight * 0.2,
                  width: constraints.maxWidth,
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                            child: Text(
                                'Felipe o LobbyAnimation ta quebrado parça')),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    StatelessSection(
                        sectionTitle: 'Dicas, Informações e Investimentos',
                        sectionHeight: 255,
                        items: [
                          LobbyInfoCard(
                              titulo: 'titulo', descricao: 'descricao')
                        ]),
                    FutureBuilder(
                        future: MyWallet.noticiasService
                            .getNoticiasTurma(_turmaProvider.turma.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Text(
                                'Um erro ocorreu ao procurar notícias.');
                          if (!snapshot.hasData)
                            return Center(child: CircularProgressIndicator());
                          if (snapshot.data!.isEmpty)
                            return Text('Nenhuma notícia encontrada.');

                          List<Noticia> noticias = snapshot.data!;

                          return StatefulSection(
                              sectionTitle: 'Notícias',
                              sectionHeight: 150,
                              items: noticias
                                  .map((x) => LobbyNoticiaCard(noticia: x))
                                  .toList());
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LobbyAnimation extends StatefulWidget {
  const LobbyAnimation({
    super.key,
  });

  @override
  State<LobbyAnimation> createState() => _LobbyAnimationState();
}

class _LobbyAnimationState extends State<LobbyAnimation> {
  double left = 20;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          child: Text('Hey'),
          left: left,
          curve: Curves.easeIn,
          duration: Duration(
            seconds: 2,
          ),
          onEnd: () {
            setState(() {
              left = 40;
            });
          },
        ),
      ],
    );
  }
}

// class LobbyNoticiasWidget extends StatelessWidget {
//   late final TurmaProvider _turmaProvider;

//   @override
//   Widget build(BuildContext context) {
//     _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);

//     return FutureBuilder(
//       future:
//           MyWallet.noticiasService.getNoticiasTurma(_turmaProvider.turma.id),
//       builder: (ctx, snapshot) {
//         if (snapshot.hasError) {
//           return const Text('Erro ao carregar noticias');
//         }

//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.data!.isEmpty) {
//           return const Text('Nenhuma noticia foi encontrada');
//         }

//         final noticias = snapshot.data!;

//         return Section(
//           sectionTitle: 'Dicas, Informações e Investimentos',
//           sectionHeight: 255,
//           items: noticias.map((n) => NewsCard(noticia: n)).toList(),
//         );
//       },
//     );
//   }
// }
