import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_wallet/app/cadastro/mw_form_input.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TurmaCadastroView extends StatefulWidget {
  const TurmaCadastroView({super.key});

  @override
  State<TurmaCadastroView> createState() => _TurmaCadastroViewState();
}

class _TurmaCadastroViewState extends State<TurmaCadastroView> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? professorSelecionado;
  int escolaridade = 1;
  int idInstituicaoEnsino = 0;
  late Future<List<Map<String, dynamic>>> fetchProfessores;

  List<(String nome, int id)> escolaridades = [
    ('Ensino Fundamental', 1),
    ('Ensino Médio', 2),
    ('Ensino Superior', 3),
  ];

  TextEditingController nomeController = TextEditingController();

  void _selecionaNivelEscolar(int? nivel) async {
    if (nivel == null) return;
    setState(() {
      escolaridade = nivel;
    });
  }

  Future<void> cadastrarTurma() async {
    try {
      await Supabase.instance.client.from('turma').insert({
        'nome': nomeController.text,
        'nivel_escolaridade': escolaridade,
        'idProfessor': professorSelecionado!['id'],
        'id_instituicao_ensino': idInstituicaoEnsino
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Sucesso!'),
            content: const Text('Turma cadastrada com sucesso!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: Text(e.toString()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>> getProfessores() async {
    return await Supabase.instance.client.from('professor').select();
  }

  @override
  initState() {
    super.initState();
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    idInstituicaoEnsino = userProvider.usuario.idInstituicaoEnsino;
    fetchProfessores = getProfessores();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Cadastrar nova Turma',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyWalletFormInput(
                        label: 'Nome da Turma',
                        controller: nomeController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }

                          value = value.trim();
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MyWalletDropdown(
                        escolaridades: escolaridades,
                        escolaridade: escolaridade,
                        onChange: _selecionaNivelEscolar,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: fetchProfessores,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final professoresData = snapshot.data!;
                                print(professorSelecionado);
                                if (professorSelecionado == null) {
                                  professorSelecionado = professoresData[0];
                                }

                                return StatefulBuilder(
                                  builder: (context, setState) =>
                                      DropdownButton<Map<String, dynamic>>(
                                    isExpanded: true,
                                    value: professorSelecionado,
                                    items: professoresData
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e['nome'],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == null) return;
                                        setState(() {
                                          professorSelecionado = value;
                                        });
                                      });
                                    },
                                  ),
                                );
                              }),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          //verifica se o nome da turma já está sendo usado por outra turma
                          final response = await Supabase.instance.client
                              .from('turma')
                              .select()
                              .eq('nome', nomeController.text);
                          if (response.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Erro'),
                                content: Text('Esse nome já está em uso!'),
                              ),
                            );
                            return;
                          }

                          //verifica se o professor escolhido já está em uma turma
                          //No futuro, um professor poderá ter várias turmas, mas por enquanto isso não será possível
                          final response2 = await Supabase.instance.client
                              .from('turma')
                              .select()
                              .eq('idProfessor', professorSelecionado!['id']);
                          if (response2.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Erro'),
                                content: Text(
                                  'Esse professor já está em uma turma!',
                                ),
                              ),
                            );
                            return;
                          }

                          cadastrarTurma();
                        },
                        child: const Text('Cadastrar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyWalletDropdown extends StatelessWidget {
  const MyWalletDropdown({
    super.key,
    required this.escolaridades,
    required this.escolaridade,
    required this.onChange,
  });

  final void Function(int?) onChange;

  final List<(String, int)> escolaridades;
  final int escolaridade;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButton(
          isExpanded: true,
          value: escolaridades[escolaridade - 1].$2,
          items: escolaridades
              .map(
                (tuple) => DropdownMenuItem(
                  value: tuple.$2,
                  child: Text(
                    tuple.$1,
                  ),
                ),
              )
              .toList(),
          onChanged: onChange,
        ),
      ),
    );
  }
}
