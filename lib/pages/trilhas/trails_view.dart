import 'package:flutter/material.dart';
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
  Future<List<Map<String, dynamic>>> fetchTrilhas() async {
    if (_user_provider.role == Role.professor) {
      return await Supabase.instance.client.from('trilha').select();
    } else {
      return await Supabase.instance.client
          .from('trilha_turma')
          .select()
          .eq('id_turma', _user_provider.id_turma);
    }
  }

  late final UserProvider _user_provider;

  @override
  void initState() {
    super.initState();
    _user_provider = Provider.of<UserProvider>(context, listen: false);
  }

  Future<void> liberarTrilha(int trilhaID) async {
    await Supabase.instance.client.from('trilha_turma').insert({
      'id_turma': _user_provider.professor!.id_turma,
      'id_trilha': trilhaID
    });
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
            future: Supabase.instance.client.from('trilha').select('*'),
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
                      liberarTrilha),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class TrailItem extends StatelessWidget {
  final Trail trail;
  final Future<void> Function(int) liberarTrilha;
  const TrailItem(this.trail, this.liberarTrilha, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondary;
    UserProvider _user_provider =
        Provider.of<UserProvider>(context, listen: true);

    if (trail.completed) {
      color = color.withOpacity(0.5);
    }

    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/home/trails/trail',
                arguments: trail);
          },
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
                        trail.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        trail.description,
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
                  onPressed: () {
                    liberarTrilha(trail.id);
                  },
                  icon: Icon(
                    trail.completed ? Icons.check_rounded : Icons.lock,
                  ),
                )
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

class TrailView extends StatelessWidget {
  const TrailView({super.key});

  @override
  Widget build(BuildContext context) {
    Trail trail = ModalRoute.of(context)!.settings.arguments as Trail;

    return Scaffold(
      body: Column(
        children: [
          Text(
            trail.name,
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}
