import 'package:flutter/material.dart';

import 'package:aula02/model/produto.dart';

import 'package:aula02/screen/perfilScreen.dart';
import 'package:aula02/screen/produtosScreen.dart';
import 'package:aula02/screen/carrinhoScreen.dart';
import 'package:aula02/screen/authScreen.dart';
import 'package:aula02/screen/produtosDetalhes.dart';

import 'package:aula02/services/produtos_service.dart';
import 'package:aula02/services/carrinhoService.dart';
import 'package:aula02/services/session_service.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;
  final _service = ProdutosService();
  Future<List<Produto>>? _listaProdutos;
  //---------------------------------
  // Lista de páginas que correspondem às abas do nav
  @override
  void initState() {
    super.initState();

    _listaProdutos = listarProdutos();
  }

  // --------- NAV DE NAVEGACAO ENTRE PAGINAS ----------
  Widget build(BuildContext context) {
    final pages = [
      //paginas que aparecem no nav
      _homePage(),
      ProdutosScreen(),
      CarrinhoScreen(),
      PerfilScreen(),
    ];

    return Scaffold(
      // aqui o body muda conforme a aba selecionada
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        //mostra o botão do nav que esta selecionado/icone destacado
        currentIndex: _currentIndex,

        //roda quando o usuario muda a aba
        onTap: (index) async {
          if (index == 4) {
            // chama o session service e limpa a sessão
            await SessionService().limparToken();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
            return;
          }

          // troca de abas normal
          setState(() {
            _currentIndex = index;
          });
        },

        //comportamento visual da barra, icone em tamanho fixo -> tem shifting que o selecionado cresce
        type: BottomNavigationBarType.fixed,

        //lista dos itens
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smartphone),
            label: 'Produtos',
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrinho',
            backgroundColor: Colors.lightBlueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Sair',
            backgroundColor: Color.fromARGB(255, 33, 243, 149),
          ),
        ],
      ),
    );
  }

  //------------ Listar produtos -------------------
  Future<List<Produto>> listarProdutos() async {
    String token = await SessionService().obterToken();

    return await _service.listarProdutos(token);
  }

  //-------------- PAGINA INICIAL-------------------

  Widget _homePage() {
    return FutureBuilder<List<Produto>>(
      future: _listaProdutos,

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final produtos = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: produtos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12, // Espaçamento horizontal entre os cards
            mainAxisSpacing: 12, // Espaçamento vertical entre os cards
            childAspectRatio: 0.56, // Proporção do card (largura / altura)
          ),
          itemBuilder: (context, index) {
            final produto = produtos[index];

            return Card(
              elevation: 4,
              margin: EdgeInsets.zero, // O GridView já controla os espaçamentos
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Imagem adaptável ao espaço do Grid
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://picsum.photos/200',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Nome do Produto limitado para não empurrar os botões
                    Text(
                      produto.nome,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ ${produto.valor}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Botão Ver Mais
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  produtosDetalhes(id: produto.id),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Ver mais',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Botão Comprar
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: () {
                          CarrinhoService().adicionar(produto);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Produto adicionado ao carrinho"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "Comprar",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
