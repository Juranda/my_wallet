import 'package:my_wallet/models/expenses/conta.dart';
import 'package:my_wallet/models/expenses/transacao.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExpensesService {
  Future<Conta> getContaAluno(int idInstituicao, int idAluno) async {
    var contaMap = await Supabase.instance.client
        .from('aluno')
        .select(
            'id, dinheiro, usuario(id, instituicaoensino(id), transacao(id, valor, nome, realizada_em, categoria(nome)))')
        .eq('id', idAluno)
        .limit(1)
        .single();

    List<Transacao> transacoes = [];

    for (Map<String, dynamic> transacaoMap in contaMap['usuario']
        ['transacao']) {
      transacoes.add(Transacao(
        id: transacaoMap['id'],
        idAluno: idAluno,
        nome: transacaoMap['nome'],
        valor: transacaoMap['valor'].toDouble(),
        realizadaEm: DateTime.parse(transacaoMap['realizada_em']),
        categoria: transacaoMap['categoria']['nome'],
      ));
    }

    Conta conta = Conta(
      idAluno: idAluno,
      dinheiro: contaMap['dinheiro'].toDouble(),
      transacoes: transacoes,
    );

    return conta;
  }

  Stream<Conta> streamConta(int idInstituicao, int idAluno) {
    return Supabase.instance.client.from('transacao').stream(
      primaryKey: ['id'],
    ).asyncMap((event) async {
      return await getContaAluno(idInstituicao, idAluno);
    });
  }
}
