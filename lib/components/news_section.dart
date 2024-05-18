import 'package:flutter/material.dart';
import 'package:my_wallet/components/trail_lobby_card.dart';
import 'package:my_wallet/components/trail_lobby_news_card.dart';
import 'package:my_wallet/pages/lobby_adicionar_noticia.dart';
import 'package:my_wallet/role_provider.dart';
import 'package:provider/provider.dart';

class NewsSection extends StatefulWidget {
  final String sectionTitle;
  final List<Widget>? items;
  final double sectionHeight;

  const NewsSection({
    super.key,
    this.items,
    required this.sectionTitle,
    required this.sectionHeight,
  });

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {


  adicionarNoticia(TrailLobbyNewsCard newCard) {
    setState(() {
      widget.items!.add(newCard);
    });
  }
  void removerNoticia(TrailLobbyNewsCard newCard) {
    setState(() {
      widget.items!.add(newCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context, listen:false);
    
    

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
                if(roleProvider.role == Role.professor)Container(
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
                                        content: AdicionarNoticia(adicionarNoticia: adicionarNoticia,removerNoticia: removerNoticia,),
                                      ));
                            },
                            icon: Icon(
                              Icons.add_circle,
                              size: 40,
                            )),
                  ),
                )
      ]),
          )
      ],
    );
  }
}
