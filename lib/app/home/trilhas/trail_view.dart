import 'package:flutter/material.dart';
import 'package:my_wallet/app/models/trail.dart';
import 'package:my_wallet/services/mywallet.dart';

class TrailView extends StatefulWidget {
  TrailView({super.key});

  @override
  State<TrailView> createState() => _TrailViewState();
}

class _TrailViewState extends State<TrailView> {
  late Trilha trilha;

  @override
  Widget build(BuildContext context) {
    this.trilha = ModalRoute.of(context)!.settings.arguments as Trilha;

    return Scaffold(
      appBar: AppBar(
        title: Text("${trilha.nome} - ${trilha.escolaridade.name}"),
      ),
      body: FutureBuilder(
        future: MyWallet.trailsService.getAllTrilhasDoAluno(1, 1),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('Erro'),
              content: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData == false) {
            return Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }

          return Column(
            children: snapshot.data![0].atividades.map((e) {
              return InkWell(
                onTap: () => print('Hello'),
                child: Container(
                  child: Text(e.atividade.enunciado),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
