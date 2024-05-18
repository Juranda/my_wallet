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
          Column(
            children: [
              Container(
                clipBehavior: Clip.none,
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                clipBehavior: Clip.none,
                height: 500,
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
