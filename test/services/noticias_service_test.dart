import 'package:my_wallet/services/news_service.dart';
import 'package:test/test.dart';

void main() {
  late NoticiasService noticiasService;
  setUp(() {
    noticiasService = StaticNoticiasService();
  });
  test('Noticias deve retornar noticias corretamente', () async {
    final noticias = await noticiasService.getNoticiasTurma(1, 1);

    final noticia = noticias[0];

    assert(noticia.title == 'FIIs são o futuro?');
  });
}
