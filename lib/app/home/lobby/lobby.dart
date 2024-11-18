import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/news_section.dart';
import 'package:my_wallet/app/home/lobby/section.dart';
import 'package:my_wallet/app/home/lobby/news_card.dart';
import 'package:my_wallet/app/home/lobby/trail_lobby_card.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

class Lobby extends StatelessWidget {
  const Lobby({super.key});

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
                          child: LobbyAnimation(),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    NewsSection(
                      sectionTitle: 'Notícias',
                      sectionHeight: 150,
                      items: ['FIIs', 'Cartão de Credito', 'Renda Fixa']
                          .map(
                            (e) => TrailLobbyCard(
                              trailName: e,
                              trailDescription: 'Lorem ipsum',
                            ),
                          )
                          .toList(),
                    ),
                    LobbyNoticiasWidget(),
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

class LobbyNoticiasWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late final _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    late final _turmaProvider =
        Provider.of<TurmaProvider>(context, listen: false);
    final int turma = _turmaProvider.turma.id;
    final int instituicao = _userProvider.usuario.idInstituicaoEnsino;

    return FutureBuilder(
      future: MyWallet.noticiasService.getNoticiasTurma(instituicao, turma),
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro ao carregar noticias');
        }

        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        if (snapshot.data!.isEmpty) {
          return const Text('Nenhuma noticia foi encontrada');
        }

        final noticias = snapshot.data!;

        return Section(
          sectionTitle: 'Dicas, Informações e Investimentos',
          sectionHeight: 255,
          items: noticias.map((n) => NewsCard(noticia: n)).toList(),
        );
      },
    );
  }
}
