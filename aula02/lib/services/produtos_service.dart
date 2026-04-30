import 'dart:convert';
import 'dart:io';
import 'package:aula02/model/produto.dart';
import 'package:flutter/cupertino.dart';
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

  //cadastrar produto
  Future<String> cadastrarProdutoComImagem({
    required String token,
    required Produto produto,
    File? imagemFile,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/produtos');

      var request = http.MultipartRequest(
        'POST',
        url,
      ); //necessario para receber dados mistos Texto e binarios(img por exemplo)

      request.headers.addAll({
        // montando requisição passo a passo
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      //requerindo elemento por elemento
      request.fields['nome'] = produto.nome;
      request.fields['descricao'] = produto.descricao;
      request.fields['categoria_id'] = produto.categoria.toString();
      request.fields['codigo_barras'] = produto.codigoBarras;
      request.fields['marca'] = produto.marca;
      request.fields['peso'] = produto.peso;
      request.fields['ativo'] = produto.status.toString();

      if (imagemFile != null) {
        var stream = http.ByteStream(
          imagemFile.openRead(),
        ); //passo 1 para converter img local para o request http
        var length = await imagemFile.length(); //length obtem o tamanho
        var multipartFile = http.MultipartFile(
          //cria o objeto da imagem
          'imagem',
          stream,
          length,
          filename: imagemFile.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      //verificando codigo de erro/acerto do codigo
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return 'Produto cadastrado com sucesso';
      } else {
        Text("========= Erro ============");
        return 'Erro: ${response.statusCode} - $responseBody';
      }
    } catch (e) {
      return "Erro ao cadastrar: $e";
    }
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

  Future<String> atualizarProdutoComImagem({
    required String token,
    required int id,
    required Produto produto,
    File? imagemFile,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/produtos/$id');
      var request = http.MultipartRequest('POST', url);
      request.fields['_method'] = 'PUT';

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['nome'] = produto.nome;
      request.fields['descricao'] = produto.descricao;
      request.fields['categoria_id'] = produto.categoria.toString();
      request.fields['codigo_barras'] = produto.codigoBarras;
      request.fields['marca'] = produto.marca;
      request.fields['peso'] = produto.peso;
      request.fields['ativo'] = produto.status.toString();

      if (imagemFile != null) {
        var stream = http.ByteStream(imagemFile.openRead());
        var length = await imagemFile.length();
        var multipartFile = http.MultipartFile(
          'imagem',
          stream,
          length,
          filename: imagemFile.path.split('/').last,
        );

        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return 'Produto atualizado com sucesso';
      } else {
        return 'Erro: ${response.statusCode} - $responseBody';
      }
    } catch (e) {
      return 'Erro ao atualizar: $e';
    }
  }
}
