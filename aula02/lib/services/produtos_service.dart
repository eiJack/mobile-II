import 'dart:convert';

import 'package:aula02/model/produto.dart';
import 'package:http/http.dart' as http;

class ProdutosService {
  static const String _baseUrl = "https://api.liliaborges.com.br/api";

  Future<List<Produto>> listarProdutos(String token) async {
    final url = Uri.parse('$_baseUrl/produtos');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> produtos = jsonDecode(response.body);
      return produtos.map((item) => Produto.fromJson(item)).toList();
    }
    return [];
  }

  Future<Produto> buscarProduto(int id, String token) async {
    final url = Uri.parse('$_baseUrl/produtos/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final produto = jsonDecode(response.body);
      return Produto.fromJson(produto);
    } else {
      throw Exception('Erro ao buscar produto: ${response.statusCode}');
    }
  }

  //Adicionar código para cadastrar produto em ProdutoService()
  Future<String> cadastrarProduto(String token, Produto produto) async {
    final url = Uri.parse('$_baseUrl/produtos');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(produto.toJson()),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return 'Produto cadastrado com sucesso';
    } else {
      return 'Erro ao cadastrar produto: ${response.statusCode} - ${response.body}';
    }
  }
}
