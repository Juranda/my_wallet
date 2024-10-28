import 'package:flutter/material.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  //final List<Map<String, dynamic>> atividades;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late final UserProvider _userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  calcularAcertos(List<Map<String, dynamic>> lista) {
    int acertos = 0;
    for (var item in lista) {
      if (item['resposta'] == 'alternativa_correta') {
        acertos++;
      }
    }
    double taxa = acertos / lista.length * 100;
    return "${taxa.toString()}%";
  }

  concluir() {
    return () => Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Resultados"),
            SizedBox(
              height: 50,
            ),
            FutureBuilder(
                future: fetchAtividade(),
                builder: (context, snapshot) {
                  List<Widget> resultados = [];
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return CircularProgressIndicator();
                  }

                  final resposta = snapshot.data!;
                  for (int i = 0; i < resposta.length; i++) {
                    resultados.add(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Questão ${i + 1}: "),
                        resposta[i]['resposta'] == "alternativa_correta"
                            ? Icon(Icons.check)
                            : Icon(Icons.close)
                      ],
                    ));
                  }
                  resultados.add(
                    SizedBox(
                      height: 50,
                    ),
                  );
                  resultados.add(
                      Text("Taxa de Acerto: ${calcularAcertos(resposta)}"));
                  return Column(
                    children: resultados,
                  );
                }),
            SizedBox(
              height: 50,
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
                      onPressed: concluir(), child: Text('Concluir')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}