import 'package:flutter/material.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AtividadeProfView extends StatefulWidget {
  final Atividade atividade;
  final Function atualizarViewPrincipal;
  const AtividadeProfView(
      {required this.atividade,
      required this.atualizarViewPrincipal,
      super.key});

  @override
  State<AtividadeProfView> createState() => _AtividadeProfViewState();
}

class _AtividadeProfViewState extends State<AtividadeProfView> {
  late final UserProvider _userProvider;

  List<RadioListTile> alternativas = [];
  int? _escolha;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _escolha = null;
    alternativas = [
      RadioListTile(
          key: UniqueKey(),
          title: Text("a) " + widget.atividade.respostas[0].enunciado),
          value: widget.atividade.respostas[0].sequencia,
          groupValue: _escolha,
          onChanged: null),
      RadioListTile(
          key: UniqueKey(),
          title: Text("b) " + widget.atividade.respostas[1].enunciado),
          value: widget.atividade.respostas[1].sequencia,
          groupValue: _escolha,
          onChanged: null),
      RadioListTile(
          key: UniqueKey(),
          title: Text("c) " + widget.atividade.respostas[2].enunciado),
          value: widget.atividade.respostas[2].sequencia,
          groupValue: _escolha,
          onChanged: null),
      RadioListTile(
          key: UniqueKey(),
          title: Text("d) " + widget.atividade.respostas[3].enunciado),
          value: widget.atividade.respostas[3].sequencia,
          groupValue: _escolha,
          onChanged: null),
    ];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.atividade.enunciado, textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
            ...alternativas,
          ],
        ),
      ),
    );
  }
}
