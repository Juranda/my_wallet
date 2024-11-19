import 'package:my_wallet/models/noticia.dart';
import 'package:my_wallet/services/noticias_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseNoticiasService implements NoticiasService {
  final placeHolders = [
    Noticia(
        urlNoticia: Uri(),
        titulo: 'FIIs são o futuro?',
        descricao: 'O mercado de FIIs está decaindo',
        urlImg: null,
        idProf: 1,
        idTurma: 1),
    Noticia(
        urlNoticia: Uri(),
        titulo: 'A Black Friday já começou',
        descricao: 'Dicas para usar o cartão de crédito',
        urlImg: null,
        idProf: 1,
        idTurma: 1),
    Noticia(
        urlNoticia: Uri(),
        titulo: 'Como um jogo te ensina a gastar menos?',
        descricao:
            '10 formas que um jogo tem de te ensinar a gastar menos sem você perceber',
        urlImg: null,
        idProf: 1,
        idTurma: 1),
    Noticia(
        urlNoticia: Uri(),
        titulo: 'Eleições e a B3',
        descricao: 'Como a B3 reage após as eleições nos EUA',
        urlImg: null,
        idProf: 1,
        idTurma: 1),
  ];

  Future<List<Noticia>> getNoticiasTurma(int idTurma) async {
    var response = await Supabase.instance.client
        .from('professorNoticia_recomenda')
        .select()
        .eq('fk_turma_id', idTurma);

    List<Noticia> noticias = [];
    if (response.isEmpty) return placeHolders;

    for (var noticia in response) {
      noticias.add(Noticia.fromMap(noticia));
    }

    return noticias;
  }

  Future<void> adicionarNoticiaTurma(int idTurma, Noticia noticia) async {
    await Supabase.instance.client.from('professorNoticia_recomenda').insert({
      'url': noticia.urlNoticia,
      'titulo': noticia.titulo,
      'descricao': noticia.descricao,
      'fk_turma_id': idTurma,
      'fk_usuario_id': noticia.idProf,
    });
  }

  Stream<Noticia> getNoticiasStream(int idTurma) async {}
}
