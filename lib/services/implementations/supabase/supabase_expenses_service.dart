import 'package:my_wallet/app/home/organizador_gastos/models/transaction.dart';
import 'package:my_wallet/models/expenses/categoria.dart';
import 'package:my_wallet/models/expenses/conta.dart';
import 'package:my_wallet/models/expenses/transacao.dart';
import 'package:my_wallet/models/users/aluno.dart';
import 'package:my_wallet/services/expenses_service.dart';
import 'package:my_wallet/services/mywallet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseExpensesService implements ExpensesService {
  Future<Conta> getContaAluno(int idInstituicao, int idAluno) async {
    var alunoMap = await Supabase.instance.client
        .from('aluno')
        .select(
            '*, escolaridades(id, nome), turma(id, nome), usuario(id, created_at, fk_usuario_supabase, instituicaoensino(id), tipousuario(id, tipo), transacao(id, valor, nome, realizada_em, categoria(id, nome)))')
        .eq('id', idAluno)
        .limit(1)
        .single();

    Aluno aluno = await MyWallet.userService.getAlunoPorId(idAluno);

    List<Transacao> transacoes = [];

    for (Map<String, dynamic> transacaoMap in alunoMap['usuario']
        ['transacao']) {
      transacoes.add(Transacao(
        id: transacaoMap['id'],
        aluno: aluno,
        nome: transacaoMap['nome'],
        valor: transacaoMap['valor'].toDouble(),
        realizadaEm: DateTime.parse(transacaoMap['realizada_em']),
        categoria: Categoria(
          id: transacaoMap['categoria']['id'],
          nome: transacaoMap['categoria']['nome'],
        ),
      ));
    }

    Conta conta = Conta(
      idAluno: idAluno,
      dinheiro: alunoMap['dinheiro'].toDouble(),
      transacoes: transacoes,
    );

    return conta;
  }

  Stream<Conta> getTransacoesStream({
    required int idInstituicao,
    required int idAluno,
    int limit = 10,
  }) {
    return Supabase.instance.client.from('transacao').stream(
      primaryKey: ['id'],
    ).asyncMap((event) async {
      return await getContaAluno(idInstituicao, idAluno);
    });
  }

  Future<void> inserirTransacao(CreateTransaction transacao) async {
    await Supabase.instance.client.rpc('inserir_transacao', params: {
      'p_valor': transacao.value,
      'p_nome': transacao.title,
      'usuario_id': transacao.idUsuario,
      'categoria_id': transacao.idCategoria,
      'p_realizada_em': transacao.date.toIso8601String(),
    });
  }

  Future<List<Categoria>> getCategoriasUsuario(int idAluno) async {
    List<Categoria> categorias = [];
    var result = await Supabase.instance.client
        .from('usuarioCategoria')
        .select('*')
        .eq("fk_usuario_id", idAluno);
    for (var map in result) {
      var cat = Categoria.fromMap(map);
      categorias.add(cat);
    }

    return categorias;
  }
}
