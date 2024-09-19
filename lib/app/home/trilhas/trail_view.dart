import 'package:flutter/material.dart';
import 'package:my_wallet/app/home/trilhas/exercise_view.dart';
import 'package:my_wallet/app/home/trilhas/exercises_view.dart';
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
  List<Map<String, dynamic>> alunoAtividades = [];

  @override
  Widget build(BuildContext context) {
    Trail trail = ModalRoute.of(context)!.settings.arguments as Trail;
    UserProvider _user_provider =
        Provider.of<UserProvider>(context, listen: true);

    Future<List<Map<String, dynamic>>> fetchAtividades() async {
      if (_user_provider.role == Role.professor) return [];

      //pega o id de todas as atividades de aluno_atividade desse aluno
      final atividades = await Supabase.instance.client
          .from('aluno_atividade')
          .select('*')
          .eq('id_aluno', _user_provider.aluno!.id);
      alunoAtividades = atividades;
      //transforma todos esses ids em uma lista
      final List<int> ids =
          atividades.map((e) => e['id_atividade'] as int).toList();
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
      appBar: AppBar(
        title: Text(trail.name),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchAtividades(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(
              child: const Text(
                'Nenhuma atividade nessa trilha',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: const Text('Algum erro aconteceu'),
            );
          }

          final atividades = snapshot.data!;
          return ListView.builder(
            itemCount: atividades.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> atividade = atividades[index];

              return ListTile(
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ExercisesView(index, atividades)))
                      },
                  title: Text(atividade['nome']),
                  trailing: alunoAtividades[index]['completada']
                      ? Icon(Icons.check_box_outlined)
                      : Icon(Icons.check_box_outline_blank));
            },
          );
        },
      ),
      floatingActionButton: TextButton(
        onPressed: () {
          //só para testes
          completarAtividade(1, completarTudo: true);
        },
        child: const Text(
          'Completar Todas',
        ),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
        ),
      ),
    );
  }
}
