import 'package:flutter/material.dart';
import 'package:my_wallet/models/trilha/aluno_atividade_realiza.dart';

class ResultadoDetalhes extends StatelessWidget {
  final AlunoAtividadeRealiza alunoAtividadeRealiza;
  const ResultadoDetalhes({required this.alunoAtividadeRealiza,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(alunoAtividadeRealiza.atividade.enunciado),
              Icon(alunoAtividadeRealiza.acerto ==true?Icons.check:Icons.close)
            ],
          ),
          ...alunoAtividadeRealiza.atividade.respostas.map((resposta)=> (resposta.sequencia == alunoAtividadeRealiza.opcaoSelecionada && resposta.correta == false)?Container(color: Colors.red,child: Text(' • '+resposta.enunciado)): Container(color: resposta.correta?Colors.green:null,child: Text(' • '+resposta.enunciado))).toList(),
          
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}