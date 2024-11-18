import 'package:flutter/material.dart';
import 'package:my_wallet/services/news_service.dart';

class NewsCard extends StatelessWidget {
  final Noticia noticia;

  const NewsCard({
    super.key,
    required this.noticia,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 200,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      noticia.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      noticia.content,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              if (noticia.urlImg != null)
                Expanded(
                  child: Container(
                    child: Image.network(
                      noticia.urlImg.toString(),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
