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
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'TAREFA LIBERADA!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
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
  }
}

class LobbyNoticiasWidget extends StatelessWidget {
  late final UserProvider _userProvider;
  late final TurmaProvider _turmaProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
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
