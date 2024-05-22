import 'package:flutter/material.dart';
import 'package:my_wallet/pages/account_settings/models/professor.dart';
import 'package:my_wallet/pages/account_settings/models/role.dart';
import 'package:my_wallet/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrailsView extends StatefulWidget {
  const TrailsView({super.key});

  @override
  State<TrailsView> createState() => _TrailsViewState();
}

class _TrailsViewState extends State<TrailsView> {
  late Future<List<Map<String, dynamic>>> getTrilhas;

  Future<List<Map<String, dynamic>>> fetchTrilhas() async {
    if (_user_provider.role == Role.professor) {
      return await Supabase.instance.client.from('trilha').select();
    } else {
      final response = await Supabase.instance.client
          .from('trilha_turma')
          .select('id_trilha')
          .eq('id_turma', _user_provider.id_turma);
      final List<int> ids = response.map((e) => e['id_trilha'] as int).toList();
      final newResponse = await Supabase.instance.client
          .from('trilha')
          .select()
          .inFilter('id', ids);
      return newResponse;
    }
  }

  late final UserProvider _user_provider;

  @override
  void initState() {
    super.initState();
    _user_provider = Provider.of<UserProvider>(context, listen: false);
    getTrilhas = fetchTrilhas();
  }

  Future<bool> trilhaJaLiberada(int trilhaID) async {
    final response = await Supabase.instance.client
        .from('trilha_turma')
        .select()
        .eq('id_trilha', trilhaID)
        .eq('id_turma', _user_provider.professor!.id_turma);

    return response.isNotEmpty;
  }

  Future<void> liberarTrilha(int trilhaID) async {
    if (await trilhaJaLiberada(trilhaID)) return;

    await Supabase.instance.client.from('trilha_turma').insert({
      'id_turma': _user_provider.professor!.id_turma,
      'id_trilha': trilhaID
    });

    //pra cada aluno da turma, criar a relação atividade-aluno de todas as atividades dessa trilha
    final alunos = await Supabase.instance.client
        .from('aluno')
        .select()
        .eq('id_turma', _user_provider.professor!.id_turma);
    final atividades = await Supabase.instance.client
        .from('atividade')
        .select()
        .eq('id_trilha', trilhaID);
    for (Map<String, dynamic> aluno in alunos) {
      for (Map<String, dynamic> atividade in atividades) {
        await Supabase.instance.client.from('aluno_atividade').insert({
          'liberada': atividades[0] == atividade,
          'completada': false,
          'id_aluno': aluno['id'],
          'id_atividade': atividade['id']
        });
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ensino Fundamental',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Container(
          height: MediaQuery.of(context).size.height - 244,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            //se é professor, mostre todas as trilhas
            //se for aluno, mostre só as da turma (fetch trilhas)
            future: getTrilhas,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                final trilhas = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => TrailItem(
                      Trail(trilhas[index]['id'], trilhas[index]['nome'],
                          trilhas[index]['descricao'], false),
                      liberarTrilha,
                      trilhaJaLiberada),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class TrailItem extends StatefulWidget {
  final Trail trail;
  final Future<void> Function(int) liberarTrilha;
  final Future<bool> Function(int) trilhaJaLiberada;
  const TrailItem(this.trail, this.liberarTrilha, this.trilhaJaLiberada,
      {super.key});

  @override
  State<TrailItem> createState() => _TrailItemState();
}

class _TrailItemState extends State<TrailItem> {
  late UserProvider _user_provider;

  void abrirTrilha(context) async {
    Navigator.pushNamed(context, '/home/trails/trail', arguments: widget.trail);
  }

  @override
  void initState() {
    super.initState();
    _user_provider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondary;
    if (widget.trail.completed) {
      color = color.withOpacity(0.5);
    }

    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => abrirTrilha(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 70,
                width: 70,
                child: Image.asset(
                  'assets/images/cartao_credito.png',
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.trail.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.trail.description,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (_user_provider.role == Role.professor)
                IconButton(
                    onPressed: () async {
                      if (await widget.trilhaJaLiberada(widget.trail.id)) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text('A trilha já foi liberada!'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Ok'),
                                    )
                                  ],
                                ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text('Trilha liberada!'),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Ok'),
                              )
                            ],
                          ),
                        );
                        widget.liberarTrilha(widget.trail.id);
                      }
                    },
                    icon: FutureBuilder<bool>(
                        future: widget.trilhaJaLiberada(widget.trail.id),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Icon(Icons.check);
                          } else {
                            return Icon(Icons.lock);
                          }
                        }))
            ],
          ),
        ),
      ),
    );
  }
}

class Trail {
  final int id;
  final String name;
  final String description;
  final bool completed;

  Trail(this.id, this.name, this.description, this.completed);
}

class TrailView extends StatefulWidget {
  const TrailView({super.key});

  @override
  State<TrailView> createState() => _TrailViewState();
}

class _TrailViewState extends State<TrailView> {
  @override
  Widget build(BuildContext context) {
    Trail trail = ModalRoute.of(context)!.settings.arguments as Trail;
    UserProvider _user_provider =
        Provider.of<UserProvider>(context, listen: true);

    Future<List<Map<String, dynamic>>> fetchAtividades() async {
      if (_user_provider.role == Role.professor) return [];

      //pega o id de todas as atividades de aluno_atividade desse aluno
      final response = await Supabase.instance.client
          .from('aluno_atividade')
          .select('id_atividade')
          .eq('id_aluno', _user_provider.aluno!.id);

      //transforma todos esses ids em uma lista
      final List<int> ids =
          response.map((e) => e['id_atividade'] as int).toList();

      //retorna todas as atividades que tem um desses ids e que fazem parte da trilha atual
      return await Supabase.instance.client
          .from('atividade')
          .select()
          .eq('id_trilha', trail.id)
          .inFilter('id', ids);
    }

    Future<void> completarAtividade(int atividadeID,
        {bool completarTudo = false}) async {
      if (completarTudo) {
        await Supabase.instance.client.from('aluno_atividade').update(
            {'completada': true}).eq('id_aluno', _user_provider.aluno!.id);
      } else {
        await Supabase.instance.client
            .from('aluno_atividade')
            .update({'completada': true})
            .eq('id_aluno', _user_provider.aluno!.id)
            .eq('id_atividade', atividadeID);
      }
      setState(() {});
    }

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            trail.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 244,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                future: fetchAtividades(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return CircularProgressIndicator();
                  } else {
                    final atividades = snapshot.data!;
                    return ListView.builder(
                        itemCount: atividades.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(atividades[index]['descricao']),
                            trailing: Text(atividades[index]['id'].toString()),
                          );
                        });
                  }
                }),
          ),
          ElevatedButton(
              onPressed: () {
                //só para testes
                completarAtividade(1, completarTudo: true);
              },
              child: Text('completar todas as atividades!!! (muito facil)'))
        ],
      ),
    );
  }
}
