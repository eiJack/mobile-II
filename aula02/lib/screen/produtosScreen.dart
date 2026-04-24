import 'package:aula02/screen/produtosDetalhes.dart';
import 'package:aula02/screen/cadastroProduto.dart';
import 'package:flutter/material.dart';
import 'package:aula02/model/produto.dart';
import 'package:aula02/services/produtos_service.dart';
import 'package:aula02/services/session_service.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  //------------------------------------------------------
  int? produtoSelecionado;
  final _service = ProdutosService();
  late Future<List<Produto>> _listaProdutos;

  @override
  //void initState() {
  //super.initState();
  //setState(() {
  //alterar estado de variavel
  //_listaProdutos = listarProdutos();
  //});
  //}
  void initState() {
    super.initState();
    setState(() {
      if (_pesquisa.text.trim().isEmpty) {
        _listaProdutos = listarProdutos();
      } else {
        _filtrarProdutos();
      }
    });
  }

  Future<List<Produto>> listarProdutos() async {
    String token = await SessionService().obterToken();
    return await _service.listarProdutos(token);
  }

  //------------------------------------------------------
  final _pesquisa = TextEditingController();
  void _filtrarProdutos() {
    String busca = _pesquisa.text.trim().toLowerCase();
    setState(() {
      _listaProdutos = listarProdutos().then(
        (p) => p.where((produto) {
          return produto.nome.toLowerCase().contains(busca) ||
              produto.marca.toLowerCase().contains(busca);
        }).toList(),
      );
    });
  }

  //------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (produtoSelecionado != null) {
      return produtosDetalhes(
        id: produtoSelecionado!,
        onVoltar: () {
          setState(() {
            produtoSelecionado = null;
          });
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de produtos"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _pesquisa,
                  onChanged: (valor) => _filtrarProdutos(),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //objetivos dentro do body
      //refreshIndicator -> futureBilder -> listView -> card -> listTile (onTap)
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _listaProdutos = listarProdutos();
          });
        },
        child: FutureBuilder(
          future: _listaProdutos,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final produtos = snapshot.data!;
            if (produtos.isEmpty) {
              return Center(
                //resposta dada caso retorne vazio
                child: Text("Não ha produtos cadastrados"),
              );
            }

            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(produtos[index].nome),
                    subtitle: Text(
                      '${produtos[index].descricao} - ${produtos[index].marca}',
                    ),
                    leading: CircleAvatar(
                      child: Icon(Icons.shopping_cart),
                    ), //esquerda do texto
                    trailing: Icon(Icons.arrow_forward), //direita do texto
                    onTap: () => {
                      //produtos_detalhes.dart produtos[index].id
                      setState(() {
                        produtoSelecionado = produtos[index].id;
                      }),
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => cadastroProduto()),
        ),
      ),
    );
  }
}
