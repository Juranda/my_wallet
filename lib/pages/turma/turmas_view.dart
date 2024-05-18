import 'package:flutter/material.dart';
import 'package:my_wallet/components/aluno_perfil.dart';
import 'package:my_wallet/pages/turma/turma_adiconar_aluno.dart';
import 'package:my_wallet/role_provider.dart';
import 'package:provider/provider.dart';

class TurmasView extends StatefulWidget {
  TurmasView({super.key});

  @override
  State<TurmasView> createState() => _TurmasViewState();
}

class _TurmasViewState extends State<TurmasView> {
  List<AlunoProfile> alunos = [];

  _TurmasViewState() {
    alunos =
        List.generate(30, (index) => AlunoProfile(alunos, index, removeAluno));
  }

  void removeAluno(AlunoProfile target) {
    setState(() {
      alunos.remove(target);
      print(alunos.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _roleProvider =
        Provider.of<UserProvider>(context, listen: true);
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Container(
            height: 60,
            width: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: Text(
                'Turmas',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Gerenciar notícias'),
                TextButton(onPressed: () {}, child: Text('Recomendar notícia'))
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                clipBehavior: Clip.none,
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Professor',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                padding: EdgeInsets.all(20),
              ),
              Positioned(
                top: 80,
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 50,
                      ),
                      Text('Nome')
                    ],
                  ),
                ),
              )
            ],
          ),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                clipBehavior: Clip.none,
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(25)),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Alunos (${alunos.length})',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center),
                    if (_roleProvider.role == Role.professor)
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Adicionar Aluno'),
                              content: AdicionarAluno(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_circle,
                          size: 40,
                        ),
                      ),
                  ],
                ),
                padding: EdgeInsets.all(20),
              ),
              Positioned(
                  top: 80,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    clipBehavior: Clip.none,
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListView(
                        children: [...alunos],
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
