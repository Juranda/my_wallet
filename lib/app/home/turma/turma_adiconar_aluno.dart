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

  List<AlunoListTile> alunosTile = [];
  List<Aluno> alunos = [];

  @override
  void initState() {
    super.initState();
    _turmaProvider = Provider.of<TurmaProvider>(context, listen: false);
  }

  void removerAluno(int id) {
    setState(() {
      alunosTile.removeWhere((x) => x.tileID == id);
    });
  }

  Future<void> fetchAluno(String email) async {
    final response = await Supabase.instance.client
        .from('view_aluno')
        .select()
        .eq('email', email)
        .maybeSingle();
    if (response != null && !response.isEmpty) {
      if (alunosTile.any((x) => x.tileID == response['id'])) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Aluno já está na lista'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok'),
                    )
                  ],
                ));
        return;
      }
      setState(() {
        alunosTile.add(AlunoListTile(
            nome: response['nome'],
            tileID: response['id'],
            removerAluno: removerAluno));
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Aluno não encontrado'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Ok'),
                  )
                ],
              ));
    }
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
                      fetchAluno(_emailController.text);
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
            children: [...alunosTile],
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                MyWallet.turmaService
                    .adicionarAlunos(alunosTile, _turmaProvider.turma.id);
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
