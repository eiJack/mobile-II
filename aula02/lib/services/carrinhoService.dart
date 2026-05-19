import 'package:aula02/database/database.dart';
import 'package:aula02/model/produto.dart';

class CarrinhoService {
  final ConectarDatabase _conexao = ConectarDatabase();

  // adicionar produto
  Future<void> adicionar(Produto produto) async {
    final db = await _conexao.abrirBanco();

    // Verifica se o item já existe para incrementar a quantidade
    final List<Map<String, dynamic>> maps = await db.query(
      'carrinho',
      where: 'id = ?',
      whereArgs: [produto.id.toString()],
    );

    if (maps.isNotEmpty) {
      int qtdAtual = maps.first['quantidade'] as int;
      await db.update(
        'carrinho',
        {'quantidade': qtdAtual + 1},
        where: 'id = ?',
        whereArgs: [produto.id.toString()],
      );
    } else {
      await db.insert('carrinho', {
        'id': produto.id.toString(),
        'nome': produto.nome,
        'valor': produto.valor,
        'quantidade': 1,
      });
    }
  }

  // listar os itens
  Future<List<Map<String, dynamic>>> listarItens() async {
    final db = await _conexao.abrirBanco();
    return await db.query('carrinho');
  }

  //adicionar quantidade
  Future<void> aumentarQuantidade(String id) async {
    final db = await _conexao.abrirBanco();
    await db.rawUpdate(
      'UPDATE carrinho SET quantidade = quantidade + 1 WHERE id = ?',
      [id],
    );
  }

  //tirar quantidade
  Future<void> diminuirQuantidade(String id) async {
    final db = await _conexao.abrirBanco();

    final List<Map<String, dynamic>> maps = await db.query(
      'carrinho',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      int qtdAtual = maps.first['quantidade'] as int;
      if (qtdAtual > 1) {
        await db.update(
          'carrinho',
          {'quantidade': qtdAtual - 1},
          where: 'id = ?',
          whereArgs: [id],
        );
      } else {
        await remover(id);
      }
    }
  }

  // remover item
  Future<void> remover(String id) async {
    final db = await _conexao.abrirBanco();
    await db.delete('carrinho', where: 'id = ?', whereArgs: [id]);
  }

  // limpar carrinho
  Future<void> limparCarrinho() async {
    final db = await _conexao.abrirBanco();
    await db.delete('carrinho');
  }
}
