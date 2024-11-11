class Categoria {
  final int id;
  final String nome;

  const Categoria({required this.id, required this.nome});

  factory Categoria.fromMap(Map<String, dynamic> result) {
    return Categoria(id: result['id'], nome: result['nome']);
  }
}
