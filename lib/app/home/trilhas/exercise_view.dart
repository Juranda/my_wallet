import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseView extends StatefulWidget {
  final List<Map<String, dynamic>> atividades;
  final int index;
  final Function(int) changeSelectedIndex;
  final List<int> ordem;

  const ExerciseView(
      this.index, this.atividades, this.changeSelectedIndex, this.ordem,
      {super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  late final UserProvider _userProvider;
  bool respondida = false;
  String teste = 'legal';
  String _escolha = '';
  String numeracao = "abcd";
  bool trilhaCompletada = false;

  List<RadioListTile> alternativas = [];

  List<String> values = [
    'alternativa1',
    'alternativa2',
    'alternativa3',
    'alternativa_correta',
  ];
  List<bool> alternativa_ativa = [true, true, true, true];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    fetchRespondida();
  }

  void fetchRespondida() async {
    var response = await Supabase.instance.client
        .from('aluno_atividade')
        .select('*')
        .eq('id_atividade', widget.atividades[widget.index]['id'])
        .eq('id_aluno', _userProvider.aluno!.id);

    respondida = response[0]['completada'];

    if (respondida) {
      _escolha = response[0]['resposta'];

      int escolhaIndex = alternativas.indexOf(
          alternativas.firstWhere((element) => element.value == _escolha));
      for (int i = 0; i < alternativa_ativa.length; i++) {
        if (i != escolhaIndex) {
          alternativa_ativa[i] = false;
        }
      }
    }
    setState(() {});
  }

  verificarResposta() async {
    if (_escolha == '') return;
    await Supabase.instance.client
        .from('aluno_atividade')
        .update({'resposta': _escolha, 'completada': true})
        .eq('id_atividade', widget.atividades[widget.index]['id'])
        .eq('id_aluno', _userProvider.aluno!.id);

    int escolhaIndex = alternativas.indexOf(
        alternativas.firstWhere((element) => element.value == _escolha));
    for (int i = 0; i < alternativa_ativa.length; i++) {
      if (i != escolhaIndex) {
        alternativa_ativa[i] = false;
      }
    }
    setState(() {});
  }

  checarTrilhaCompleta() async {
    List<Map<String, dynamic>> atividadeAlunos;

    atividadeAlunos = await Supabase.instance.client
        .from('aluno_atividade')
        .select('resposta')
        .eq('id_atividade', widget.atividades[widget.index]['id'])
        .eq('id_aluno', _userProvider.aluno!.id);

    trilhaCompletada = true;
    for (var item in atividadeAlunos) {
      if (item['completada'] == false) {
        trilhaCompletada = false;
      }
    }
  }

  proximaAtividade() {
    checarTrilhaCompleta();
    if (widget.index == widget.atividades.length - 1 && !trilhaCompletada)
      return null;
    return () => widget.changeSelectedIndex(1);
  }

  anteriorAtividade() {
    if (widget.index == 0) return null;
    return () => widget.changeSelectedIndex(-1);
  }

  @override
  Widget build(BuildContext context) {
    List<String> alternativa = [
      widget.atividades[widget.index]['alternativa1'],
      widget.atividades[widget.index]['alternativa2'],
      widget.atividades[widget.index]['alternativa3'],
      widget.atividades[widget.index]['alternativa_correta'],
    ];

    alternativas = [
      RadioListTile(
          title: Text("a) " + alternativa[widget.ordem[0]]),
          value: values[widget.ordem[0]],
          groupValue: _escolha,
          onChanged: !alternativa_ativa[0]
              ? null
              : (value) {
                  setState(() {
                    _escolha = value.toString();
                  });
                }),
      RadioListTile(
          title: Text("b) " + alternativa[widget.ordem[1]]),
          value: values[widget.ordem[1]],
          groupValue: _escolha,
          onChanged: !alternativa_ativa[1]
              ? null
              : (value) {
                  setState(() {
                    _escolha = value.toString();
                  });
                }),
      RadioListTile(
          title: Text("c) " + alternativa[widget.ordem[2]]),
          value: values[widget.ordem[2]],
          groupValue: _escolha,
          onChanged: !alternativa_ativa[2]
              ? null
              : (value) {
                  setState(() {
                    _escolha = value.toString();
                  });
                }),
      RadioListTile(
          title: Text("d) " + alternativa[widget.ordem[3]]),
          value: values[widget.ordem[3]],
          groupValue: _escolha,
          onChanged: !alternativa_ativa[3]
              ? null
              : (value) {
                  setState(() {
                    _escolha = value.toString();
                  });
                }),
    ];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.atividades[widget.index]['conteudo']),
            ...alternativas,
            Container(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: respondida ? null : verificarResposta,
                    child: Text('confirmar'))),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: anteriorAtividade(), child: Text('Anterior')),
                  ElevatedButton(
                      onPressed: proximaAtividade(), child: Text('Próxima')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
