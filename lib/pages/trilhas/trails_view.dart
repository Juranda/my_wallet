import 'package:flutter/material.dart';
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
    return await Supabase.instance.client.from('trilha').select();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _user_provider =
        Provider.of<UserProvider>(context, listen: false);

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
                  itemBuilder: (context, index) => TrailItem(Trail(
                      index,
                      trilhas[index]['nome'],
                      trilhas[index]['descricao'],
                      false)),
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

  const TrailItem(this.trail, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.secondary;
    if (trail.completed) {
      color = color.withOpacity(0.5);
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/home/trails/trail',
                arguments: trail);
          },
          child: Container(
            color: color,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Image.asset(
                          'assets/images/cartao_credito.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
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
                      Container(
                        height: 70,
                        width: 70,
                        child: Icon(
                          trail.completed
                              ? Icons.check_rounded
                              : Icons.arrow_forward,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.delete),
        ),
      ],
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
