import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/lobby/lobby_info_card.dart';
import 'package:my_wallet/app/home/lobby/lobby_add_news.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/users/funcao.dart';

class StatefulSection extends StatefulWidget {
  final String sectionTitle;
  final List<Widget>? items;
  final List<Widget> addedItems = [];
  final double sectionHeight;

  StatefulSection({
    super.key,
    this.items,
    required this.sectionTitle,
    required this.sectionHeight,
  });

  @override
  State<StatefulSection> createState() => _StatefulSectionState();
}

class _StatefulSectionState extends State<StatefulSection> {
  adicionarNoticia(LobbyInfoCard newCard) {
    setState(() {
      widget.items!.clear();
    });
  }

  void removerNoticia(LobbyInfoCard newCard) {
    setState(() {
      widget.items!.add(newCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<UserProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 10),
          child: Text(
            widget.sectionTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (widget.items != null)
          Container(
            height: widget.sectionHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...widget.items!,
                ...widget.addedItems,
                if (roleProvider.tipoUsuario == Funcao.Professor)
                  Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Adicionar Notícia'),
                              content: LobbyAddNews(
                                adicionarNoticia: adicionarNoticia,
                                removerNoticia: removerNoticia,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_circle,
                          size: 40,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          )
      ],
    );
  }
}
