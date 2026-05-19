import 'package:aula02/services/carrinhoService.dart';
import 'package:flutter/material.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  List<Map<String, dynamic>> _itensCarrinho = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarItens();
  }

  Future<void> _carregarItens() async {
    setState(() => _carregando = true);
    final itens = await CarrinhoService().listarItens();
    setState(() {
      _itensCarrinho = itens;
      _carregando = false;
    });
  }

  double get _calcularTotal {
    return _itensCarrinho.fold(0.0, (soma, item) {
      double valor = double.tryParse(item['valor'].toString()) ?? 0.0;
      int qtd = item['quantidade'] as int? ?? 1;
      return soma + (valor * qtd);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Carrinho"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _itensCarrinho.isEmpty
          ? const Center(
              child: Text(
                "Seu carrinho está vazio.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _itensCarrinho.length,
                    itemBuilder: (context, index) {
                      final item = _itensCarrinho[index];
                      double valorUnidade =
                          double.tryParse(item['valor'].toString()) ?? 0.0;
                      int quantidade = item['quantidade'] as int? ?? 1;
                      double subtotalItem = valorUnidade * quantidade;
                      String itemId = item['id'].toString();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              item['nome'] ?? 'Produto',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Unitário: R\$ ${valorUnidade.toStringAsFixed(2)}\nSubtotal: R\$ ${subtotalItem.toStringAsFixed(2)}",
                            ),
                            isThreeLine: true,

                            // Controle interativo de quantidade no lado direito do Card
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botão de diminuir quantidade (-)
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await CarrinhoService().diminuirQuantidade(
                                      itemId,
                                    );
                                    _carregarItens(); // Recarrega os dados da tela
                                  },
                                ),
                                // Exibição do número da quantidade atual
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "$quantidade",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                // Botão de aumentar quantidade (+)
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    await CarrinhoService().aumentarQuantidade(
                                      itemId,
                                    );
                                    _carregarItens(); // Recarrega os dados da tela
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Corrigido para espaçar os lados perfeitamente
                        children: [
                          const Text(
                            "Total do Carrinho:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "R\$ ${_calcularTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Função em desenvolvimento",
                                    ),
                                    duration: Duration(
                                      seconds: 2,
                                    ),
                                  ),
                                );
                              },

                              style:
                                ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding:const EdgeInsets.symmetric(vertical: 14),
                                ),

                              child: const Text("Finalizar Pedido", style: TextStyle(fontSize: 16,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
