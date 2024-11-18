import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/turma/aluno_list_tile.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/providers/turma_provider.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:validadores/ValidarEmail.dart';

final _formKey = GlobalKey<FormState>();

class AdicionarAluno extends StatefulWidget {
  const AdicionarAluno({super.key});

  @override
  State<AdicionarAluno> createState() => _AdicionarAlunoState();
}

class _AdicionarAlunoState extends State<AdicionarAluno> {
  final _emailController = TextEditingController();
  late final TurmaProvider _turmaProvider;
  final adicionados = [];

  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'Please provide an valid email';
    }
    return null;
  }

  List<AlunoListTile> alunoTiles = [];
  List<Aluno> alunos = [];

  @override
  void initState() {
    super.initState();
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
  }

  void adicionarAluno(BuildContext context, String email) async {
    var aluno =
        await MyWallet.userService.getAlunoPorEmail(_emailController.text);

    //checa se encontrou aluno com esse email
    if (aluno == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Aviso'),
                content: Text('Nenhum aluno econtrado com este email.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Ok'),
                  )
                ],
              ));
      return;
    }

    //checa se aluno ja esta na turma
    if (aluno.idTurma == _turmaProvider.turma.id) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Alerta'),
                content: Text('Aluno já está nessa turma!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Ok'),
                  )
                ],
              ));
      return;
    }

    //checa se aluno ja foi selecionado
    if (alunos.any((x) => x.id == aluno.id)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Aviso'),
                content: Text('Aluno já foi selecionado!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Ok'),
                  )
                ],
              ));
      return;
    }

    //cria listTile e adiciona nas listas
    alunos.add(aluno);
    setState(() {
      alunoTiles.add(AlunoListTile(
          key: ValueKey(aluno.id), aluno: aluno, removerAluno: removerAluno));
    });
  }

  void removerAluno(int id) {
    alunoTiles.removeWhere((x) => x.aluno.id == id);
    alunos.removeWhere((x) => x.id == id);
    setState(() {});
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
                validator: (email) => EmailValidator.validate(email)
                    ? null
                    : 'Please provide an valid email',
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
                      adicionarAluno(context, _emailController.text);
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
            children: [...alunoTiles],
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                MyWallet.turmaService
                    .adicionarAlunos(alunos, _turmaProvider.turma.id);
                Navigator.pop(context);
              },
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
