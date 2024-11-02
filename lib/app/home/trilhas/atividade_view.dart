import 'package:flutter/material.dart';
import 'package:my_wallet/models/trilha/atividade.dart';
import 'package:my_wallet/models/trilha/aluno_atividade_realiza.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AtividadeView extends StatefulWidget {
  final Atividade atividade;
  final bool respostasBloqueadas;
  final AlunoAtividadeRealiza alunoRealiza;
  final Function atualizarViewPrincipal;
  const AtividadeView(
      {required this.atividade,
      required this.alunoRealiza,
      required this.atualizarViewPrincipal,
      required this.respostasBloqueadas,
      super.key});

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
    _escolha = widget.alunoRealiza.opcaoSelecionada;
    alternativas = [
      RadioListTile(
          key: UniqueKey(),
          title: Text("a) " + widget.atividade.respostas[0].enunciado),
          value: widget.atividade.respostas[0].sequencia,
          groupValue: _escolha,
          onChanged: widget.respostasBloqueadas == true?null: (value) => setState(() {
                widget.alunoRealiza.opcaoSelecionada = value;
                widget.alunoRealiza.feito = true;
                print(widget.alunoRealiza.opcaoSelecionada);
                widget.atualizarViewPrincipal();
              })),
      RadioListTile(
          key: UniqueKey(),
          title: Text("b) " + widget.atividade.respostas[1].enunciado),
          value: widget.atividade.respostas[1].sequencia,
          groupValue: _escolha,
          onChanged: widget.respostasBloqueadas == true?null:(value) => setState(() {
                widget.alunoRealiza.opcaoSelecionada = value;
                widget.alunoRealiza.feito = true;
                print(widget.alunoRealiza.opcaoSelecionada);
                widget.atualizarViewPrincipal();
              })),
      RadioListTile(
          key: UniqueKey(),
          title: Text("c) " + widget.atividade.respostas[2].enunciado),
          value: widget.atividade.respostas[2].sequencia,
          groupValue: _escolha,
          onChanged: widget.respostasBloqueadas == true?null:(value) => setState(() {
                widget.alunoRealiza.opcaoSelecionada = value;
                widget.alunoRealiza.feito = true;
                print(widget.alunoRealiza.opcaoSelecionada);
                widget.atualizarViewPrincipal();
              })),
      RadioListTile(
          key: UniqueKey(),
          title: Text("d) " + widget.atividade.respostas[3].enunciado),
          value: widget.atividade.respostas[3].sequencia,
          groupValue: _escolha,
          onChanged: widget.respostasBloqueadas == true?null:(value) => setState(() {
                widget.alunoRealiza.opcaoSelecionada = value;
                widget.alunoRealiza.feito = true;
                print(widget.alunoRealiza.opcaoSelecionada);
                widget.atualizarViewPrincipal();
              })),
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
