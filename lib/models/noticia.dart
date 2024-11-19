class Noticia {
  final Uri urlNoticia;
  final String titulo;
  final String descricao;
  final Uri? urlImg;
  final int idTurma;
  final int idProf;

  const Noticia({
    required this.urlNoticia,
    required this.titulo,
    required this.descricao,
    required this.urlImg,
    required this.idTurma,
    required this.idProf,
  });

  factory Noticia.fromMap(Map<String, dynamic> map) {
    return Noticia(
        urlNoticia: map['url'],
        titulo: map['titulo'],
        descricao: map['descricao'],
        urlImg: map['urlimg'] ?? null,
        idTurma: map['fk_turma_id'],
        idProf: map['fk_usuario_id']);
  }
}
