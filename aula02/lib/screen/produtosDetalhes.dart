import 'package:flutter/material.dart';
import 'package:aula02/model/produto.dart';
import 'package:aula02/services/produtos_service.dart';
import 'package:aula02/services/session_service.dart';

class produtosDetalhes extends StatefulWidget {
  final int id;
  final VoidCallback onVoltar;

  const produtosDetalhes({super.key, required this.id, required this.onVoltar});

  @override
  State<produtosDetalhes> createState() => _produtosDetalhesState();
}

class _produtosDetalhesState extends State<produtosDetalhes> {
  //----------------------------------------------------------
  final _service = ProdutosService();
  late Future<Produto> _futureProduto;

  @override
  void initState() {
    super.initState();
    _futureProduto = buscarProduto();
  }

  Future<Produto> buscarProduto() async {
    String token = await SessionService().obterToken();
    return await _service.buscarProduto(widget.id, token);
  }

  //----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Produto"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onVoltar,
        ),
      ),
      body: FutureBuilder<Produto>(
        future: _futureProduto,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Produto não encontrado"));
          }

          final produto = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.nome,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(produto.descricao),
                const SizedBox(height: 10),
                Text("Marca: ${produto.marca}"),
                Text("Peso: ${produto.peso}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
