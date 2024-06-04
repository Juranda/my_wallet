import 'package:flutter/material.dart';
import 'package:my_wallet/app/models/role.dart';
import 'package:my_wallet/app/models/trail.dart';
import 'package:my_wallet/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                    return CircularProgressIndicator(
                      color: Colors.white,
                    );
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
            child: const Text(
              'completar todas as atividades!!! (muito facil)',
            ),
          )
        ],
      ),
    );
  }
}
