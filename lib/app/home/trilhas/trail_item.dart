import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/trails_view.dart';
import 'package:my_wallet/app/models/role.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/routes.dart';
import 'package:provider/provider.dart';

import '../../models/trail.dart';

class TrailItem extends StatefulWidget {
  final Trail trail;
  final Future<void> Function(int) liberarTrilha;
  final Future<bool> Function(int) trilhaJaLiberada;
  const TrailItem(this.trail, this.liberarTrilha, this.trilhaJaLiberada,
      {super.key});

  @override
  State<TrailItem> createState() => _TrailItemState();
}

class _TrailItemState extends State<TrailItem> {
  late UserProvider _user_provider;

  void abrirTrilha(context) async {
    Navigator.pushNamed(context, Routes.TRAILS_TRAIL_DETALHE,
        arguments: widget.trail);
  }

  @override
  void initState() {
    super.initState();
    _user_provider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;
    if (widget.trail.completed) {
      color = color.withOpacity(0.5);
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => abrirTrilha(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 70,
                width: 70,
                child: Image.asset(
                  'assets/images/cartao_credito.png',
                  fit: BoxFit.contain,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.trail.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.trail.description,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (_user_provider.role == Role.professor)
                IconButton(
                    onPressed: () async {
                      if (await widget.trilhaJaLiberada(widget.trail.id)) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text('A trilha já foi liberada!'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Ok'),
                                    )
                                  ],
                                ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text('Trilha liberada!'),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Ok'),
                              )
                            ],
                          ),
                        );
                        widget.liberarTrilha(widget.trail.id);
                      }
                    },
                    icon: FutureBuilder<bool>(
                        future: widget.trilhaJaLiberada(widget.trail.id),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Icon(Icons.check);
                          } else {
                            return Icon(Icons.lock);
                          }
                        }))
            ],
          ),
        ),
      ),
    );
  }
}
