import 'package:my_wallet/models/noticia.dart';

abstract class NoticiasService {
  Future<List<Noticia>> getNoticiasTurma(int idTurma);
  Future<void> adicionarNoticiaTurma(int idTurma, Noticia noticia);
}
