import 'package:my_wallet/models/expenses/transacao.dart';
import 'package:my_wallet/services/expenses_service.dart';

class Conta {
  final int idAluno;
  final double dinheiro;
  final List<Transacao> transacoes;

  Conta({
    required this.idAluno,
    required this.dinheiro,
    required this.transacoes,
  });
}
