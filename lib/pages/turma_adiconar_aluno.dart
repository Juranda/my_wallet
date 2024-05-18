import 'package:flutter/material.dart';
import 'package:my_wallet/components/aluno_profile.dart';

final _formKey = GlobalKey<FormState>();

class AdicionarAluno extends StatefulWidget {
  const AdicionarAluno({super.key});

  @override
  State<AdicionarAluno> createState() => _AdicionarAlunoState();
}

class _AdicionarAlunoState extends State<AdicionarAluno> {
  final _emailController = TextEditingController();
  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please provide an valid email';
    }
    return null;
  }

  List<AlunoProfile> alunos = [];

  _AdicionarAlunoState() {
    //alunos = List.generate(5, (index) => AlunoProfile(alunos,index, removeAluno));
  }

  void removeAluno(AlunoProfile target) {
    setState(() {
      alunos.remove(target);
      print(alunos.length);
    });
  }

  void adicionaAluno(AlunoProfile novoAluno) {
    setState(() {
      alunos.add(novoAluno);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: validateEmail,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      ),
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'aluno@dominio.com',
                  labelText: 'email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      adicionaAluno(
                          AlunoProfile(alunos, alunos.length, removeAluno));
                      _emailController.clear();
                    }
                  },
                  child: Text(
                    'Adicionar',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                ),
              )
            ],
          ),
        ),
        Divider(),
        Text(
          'Alunos Adicionados',
          style: TextStyle(fontSize: 20),
        ),
        Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [...alunos],
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.secondary),
              child: Text(
                'Ok',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        )
      ],
    );
  }
}
