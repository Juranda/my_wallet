import 'package:flutter/material.dart';
import 'package:my_wallet/models/trilha/aluno_trilha_realiza.dart';
import 'package:my_wallet/models/users/funcao.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/routes.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';


class AlunoTrilhaItem extends StatefulWidget {
  final AlunoTrilhaRealiza trilhaAlunoRealiza;
  const AlunoTrilhaItem(this.trilhaAlunoRealiza, {super.key});

  @override
  State<AlunoTrilhaItem> createState() => _AlunoTrilhaItemState();
}

class _AlunoTrilhaItemState extends State<AlunoTrilhaItem> {
  late final TurmaProvider _turmaProvider;

  void abrirTrilha(context) async {
    Navigator.pushNamed(context, Routes.TRAILS_TRAIL_DETALHE,
        arguments: widget.trilhaAlunoRealiza);
  }

  @override
  void initState() {
    super.initState();
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
          onTap: ()=>abrirTrilha(context),
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
                        widget.trilhaAlunoRealiza.trilha.nome,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.left,
                      ),
                    ],
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
