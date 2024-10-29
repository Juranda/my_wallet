import 'package:flutter/material.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/aluno_atividade_realiza.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AtividadeView extends StatefulWidget {
  final Atividade atividade;
  final AlunoAtividadeRealiza alunoRealiza;
  final int? Function(int) getRespostaSelecionada;
  final Function(int, int) setRespostaSelecionada;
  const AtividadeView({required this.atividade, required this.alunoRealiza, required this.getRespostaSelecionada, required this.setRespostaSelecionada, super.key});

  @override
  State<AtividadeView> createState() => _AtividadeViewState();
}

class _AtividadeViewState extends State<AtividadeView> {
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
    print(_escolha);
  _escolha = widget.getRespostaSelecionada(widget.atividade.id);
    alternativas = [
      RadioListTile(
          key: UniqueKey() ,
          title: Text("a) " + widget.atividade.respostas[0].enunciado),
          value: widget.atividade.respostas[0].sequencia,
          groupValue: _escolha,
          onChanged: (value) => setState(() {
            widget.setRespostaSelecionada(widget.atividade.id, value);
          })
          ),
      RadioListTile(
          key: UniqueKey() ,
          title: Text("b) " + widget.atividade.respostas[1].enunciado),
          value: widget.atividade.respostas[1].sequencia,
          groupValue: _escolha,
          onChanged: (value) => setState(() {
            widget.setRespostaSelecionada(widget.atividade.id, value);
          })
          ),
      RadioListTile(
          key: UniqueKey() ,
          title: Text("c) " + widget.atividade.respostas[2].enunciado),
          value: widget.atividade.respostas[2].sequencia,
          groupValue: _escolha,
          onChanged: (value) => setState(() {
            widget.setRespostaSelecionada(widget.atividade.id, value);
          })
          ),
      RadioListTile(
          key: UniqueKey() ,
          title: Text("d) " + widget.atividade.respostas[3].enunciado),
          value: widget.atividade.respostas[3].sequencia,
          groupValue: _escolha,
          onChanged: (value) => setState(() {
            widget.setRespostaSelecionada(widget.atividade.id, value);
          })
          ),
    ];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.atividade.enunciado),
            ...alternativas,
          ],
        ),
      ),
    );
  }
}
