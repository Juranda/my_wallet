import 'package:flutter/material.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../models/role.dart';

class TrailLobbyNewsCard extends StatelessWidget {
  final String trailName;
  final String trailDescription;
  final void Function(TrailLobbyNewsCard) removeCard;

  const TrailLobbyNewsCard(
      {super.key,
      required this.trailName,
      required this.trailDescription,
      required this.removeCard});

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<UserProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 150,
        width: 200,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        trailName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (roleProvider.tipoUsuario == Role.Professor)
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Remover Notícia?'),
                                        content: Row(
                                          children: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    foregroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                                child: Text('Ok'))
                                          ],
                                        ),
                                      ));
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 40,
                            ))
                    ],
                  ),
                  Text(
                    trailDescription,
                  )
                ],
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
