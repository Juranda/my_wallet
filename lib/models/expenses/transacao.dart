import 'package:my_wallet/models/expenses/categoria.dart';
import 'package:my_wallet/models/users/aluno.dart';

class Transacao {
  final int id;
  final Aluno aluno;
  final String nome;
  final double valor;
  final Categoria categoria;
  final DateTime realizadaEm;

  Transacao({
    required this.id,
    required this.aluno,
    required this.nome,
    required this.valor,
    required this.realizadaEm,
    required this.categoria,
  });
}
