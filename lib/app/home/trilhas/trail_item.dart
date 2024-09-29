import 'package:flutter/material.dart';
import 'package:my_wallet/models/users/role.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';

import '../../../models/trilha/trail.dart';

class TrailItem extends StatefulWidget {
  final Trilha trail;
  const TrailItem(this.trail,{super.key});

  @override
  State<TrailItem> createState() => _TrailItemState();
}

class _TrailItemState extends State<TrailItem> {
  late final UserProvider _user_provider;
  late final TurmaProvider _turmaProvider;

  void abrirTrilha(context) async {
    Navigator.pushNamed(context, Routes.TRAILS_TRAIL_DETALHE,
        arguments: widget.trail);
  }

  @override
  void initState() {
    super.initState();
    _user_provider = Provider.of<UserProvider>(context, listen: false);
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: _user_provider.eAluno ? () => abrirTrilha(context) : null,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.trail.nome,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              if (_user_provider.tipoUsuario == Role.Professor)
                IconButton(
                  onPressed: () async {
                    if (await MyWallet.trailsService.trilhaJaLiberada(widget.trail.id, _turmaProvider.turma.id)) {
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
                        ),
                      );
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
                      MyWallet.trailsService.liberarTrilha(widget.trail.id,_turmaProvider.turma.id);
                    }
                  },
                  icon: FutureBuilder<bool>(
                    future: MyWallet.trailsService.trilhaJaLiberada(widget.trail.id, _turmaProvider.turma.id),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        return Icon(Icons.check);
                      } else {
                        return Icon(Icons.lock);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
