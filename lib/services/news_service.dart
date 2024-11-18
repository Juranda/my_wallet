class Noticia {
  final Uri urlNoticia;
  final String title;
  final String content;
  final Uri? urlImg;

  const Noticia({
    required this.urlNoticia,
    required this.title,
    required this.content,
    required this.urlImg,
  });
}

abstract class NoticiasService {
  Future<List<Noticia>> getNoticiasTurma(int idInstituicao, int idTurma);
}

class StaticNoticiasService implements NoticiasService {
  final noticias = [
    Noticia(
      urlNoticia: Uri(),
      title: 'FIIs são o futuro?',
      content: 'O mercado de FIIs está decaindo',
      urlImg: null,
    ),
    Noticia(
      urlNoticia: Uri(),
      title: 'A Black Friday já começou',
      content: 'Dicas para usar o cartão de crédito',
      urlImg: null,
    ),
    Noticia(
      urlNoticia: Uri(),
      title: 'Como um jogo te ensina a gastar menos?',
      content:
          '10 formas que um jogo tem de te ensinar a gastar menos sem você perceber',
      urlImg: null,
    ),
    Noticia(
      urlNoticia: Uri(),
      title: 'Eleições e a B3',
      content: 'Como a B3 reage após as eleições nos EUA',
      urlImg: null,
    ),
  ];

  @override
  Future<List<Noticia>> getNoticiasTurma(int idInstituicao, int idTurma) async {
    return noticias;
  }
}
