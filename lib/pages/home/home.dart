import 'package:flutter/material.dart';
import 'package:my_wallet/components/news_section.dart';
import 'package:my_wallet/components/section.dart';
import 'package:my_wallet/components/news_card.dart';
import 'package:my_wallet/components/trail_lobby_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                          color: Theme.of(context).colorScheme.secondary,
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
                Section(
                  sectionTitle: 'Dicas e informações',
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
                Section(
                  sectionTitle: 'Investimentos',
                  sectionHeight: 225,
                  items: ['FIIs', 'Cartão de Credito', 'Renda Fixa', 'CDB']
                      .map(
                        (e) => NewsCard(
                          title: '$e',
                          description:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ut commodo dolor, eu condimentum tortor. Duis luctus mauris ut pellentesque tincidunt. In tincidunt lectus id augue tincidunt, sit amet ultrices ante interdum. Vestibulum accumsan pharetra pellentesque. Aliquam in dolor nec risus hendrerit sagittis. Etiam cursus pellentesque orci eu venenatis. Quisque consectetur mattis porttitor. Integer eu magna non nisl dignissim dignissim sit amet non velit. Mauris sed orci sit amet mauris feugiat viverra. Praesent pulvinar mi diam, non elementum lacus pharetra vitae. Etiam ultrices arcu mauris, ac condimentum diam rutrum ut. Maecenas malesuada nunc et lobortis ornare. Donec id posuere dui, eget efficitur sem. Vestibulum ac risus nunc.',
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
