import 'package:my_wallet/app/models/role.dart';
import 'package:my_wallet/app/models/trail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrailsService {
  Future<List<Trail>> getAllTrails(int idTurma) async {
    return [];
    // if (usuario.tipoUsuario == Role.Professor) {
    //   List<Trail> trails = [];

    //   var maps = await Supabase.instance.client.from('trilhas').select();
    //   maps.forEach((element) {
    //     trails.add(Trail.fromMap(element));
    //   });

    //   return trails;
    // } else {
    //   final response = await Supabase.instance.client
    //       .from('trilha_turma')
    //       .select('id_trilha')
    //       .eq('id_turma', idTurma);
    //   final List<int> ids = response.map((e) => e['id_trilha'] as int).toList();
    //   final newResponse = await Supabase.instance.client
    //       .from('trilha')
    //       .select()
    //       .inFilter('id', idTurma);
    //   return newResponse;
    // }
  }
}
