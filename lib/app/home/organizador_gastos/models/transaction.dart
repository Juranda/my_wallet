class Transaction {
  final String id;
  final String title;
  final double value;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
  });
}

class CreateTransaction {
  final int idUsuario;
  final int idCategoria;
  final String title;
  final double value;
  final DateTime date;

  CreateTransaction({
    required this.idUsuario,
    required this.idCategoria,
    required this.title,
    required this.value,
    required this.date,
  });
}
