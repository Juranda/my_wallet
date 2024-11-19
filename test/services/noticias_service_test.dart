import 'package:my_wallet/services/implementations/supabase/supabase_noticias_service.dart';
import 'package:my_wallet/services/noticias_service.dart';
import 'package:test/test.dart';

void main() {
  late NoticiasService noticiasService;
  setUp(() {
    noticiasService = SupabaseNoticiasService();
  });
  test('Noticias deve retornar noticias corretamente', () async {
    final noticias = await noticiasService.getNoticiasTurma(1);

    final noticia = noticias[0];

    assert(noticia.titulo == 'FIIs são o futuro?');
  });
}
