import 'package:aula02/model/produto.dart';
import 'package:aula02/services/produtos_service.dart';
import 'package:aula02/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:aula02/screen/leitorCodigoBarras.dart';
import 'package:aula02/widgets/seletor_imagem.dart';
import 'dart:io';

class cadastroProduto extends StatefulWidget {
  final Produto? produto;
  const cadastroProduto({super.key, this.produto});

  @override
  State<cadastroProduto> createState() => _cadastroProdutoState();
}

class _cadastroProdutoState extends State<cadastroProduto> {
  final _formkey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _codigoBarrasController = TextEditingController();
  final _marcaController = TextEditingController();
  final _service = ProdutosService(); //chama api

  int _categoriaSelecionada = 1;
  int _status = 1;
  bool _carregando = false;
  File? _imagemSelecionada;
  String? _imagemExistente;

  @override
  void initState() {
    // inicia campos com um produto ja existente
    //onde se nao tiver sido selecionado nenhum produto (visto pelos !) é um cadastro novo e nao atualizacao
    super.initState();
    if (widget.produto != null) {
      _nomeController.text = widget.produto!.nome;
      _descricaoController.text = widget.produto!.descricao;
      _marcaController.text = widget.produto!.marca;
      _codigoBarrasController.text = widget.produto!.codigoBarras;
      _imagemExistente = widget.produto!.imagem;
      _imagemSelecionada = widget.produto!.imagem.isNotEmpty
          ? File(widget.produto!.imagem)
          : null;
      _categoriaSelecionada = widget.produto!.categoria;
      _status = widget.produto!.status;
    }
  }

  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _marcaController.dispose();
    _categoriaController.dispose();
    _codigoBarrasController.dispose();
    super.dispose();
  }

  //-----------Funcao cadastrar-------------------------
  void _cadastrarProduto() async {
    setState(() => _carregando = true);
    String token = await SessionService().obterToken();

    try {
      Produto produto = Produto(
        id: widget.produto?.id ?? 0,
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        categoria: _categoriaSelecionada,
        codigoBarras: _codigoBarrasController.text,
        marca: _nomeController.text,
        imagem: _imagemSelecionada != null ? _imagemSelecionada!.path : '',
        status: _status,
      );
      String resultado;

      //validacao - se result null, cadastra novo produto, se for ja preenchido previamente só atualiza
      if (widget.produto == null) {
        resultado = await _service.cadastrarProdutoComImagem(
          token: token,
          produto: produto,
          imagemFile: _imagemSelecionada,
        );
      } else {
        resultado = await _service.atualizarProdutoComImagem(
          token: token,
          id: widget.produto!.id,
          produto: produto,
          imagemFile: _imagemSelecionada,
        );
      }

      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado),
            backgroundColor: resultado.contains('sucesso')
                ? Colors.green
                : Colors.red,
          ),
        );

        if (resultado.contains('sucesso')) {
          Navigator.pop(context, true); // Volta e avisa que salvou
        }
      }
    } catch (e) {
      setState(() => _carregando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    }
  }

  //-------------------------------------------------------------
  Future<void> _lerCodigoBarras() async {
    final String? resultado = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => leitorCodigoBarras()),
    );
    _codigoBarrasController.text = resultado?.isNotEmpty == true
        ? resultado!
        : '';
  }

  //--------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final bool isEdicao = widget.produto != null;
    final titulo = isEdicao ? 'Editar Produto' : 'Novo Produto';

    return Scaffold(
      appBar: AppBar(title: Text(titulo), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SeletorImagem(
                imagemAtual: _imagemSelecionada,
                imagemExistente: _imagemExistente,
                quandoImagemSelecionada: (img) {
                  setState(() {
                    _imagemSelecionada = img;
                    _imagemExistente = null;
                  });
                },
              ),
              SizedBox(height: 12),

              TextFormField(
                controller: _codigoBarrasController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffix: TextButton(
                    onPressed: _lerCodigoBarras,
                    child: const Icon(Icons.qr_code_scanner),
                  ),
                  labelText: 'Codigo de Barras',
                ),
              ),
              SizedBox(height: 12),

              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'Nome do Produto',
                ),
              ),
              SizedBox(height: 12),

              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'Descricao do Produto',
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _marcaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'Marca',
                ),
              ),
              SizedBox(height: 12),

              DropdownButtonFormField(
                initialValue: _categoriaSelecionada.toString(),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Eletrônicos')),
                  DropdownMenuItem(value: '2', child: Text('Roupas')),
                  DropdownMenuItem(value: '3', child: Text('Alimentos')),
                ],
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _categoriaSelecionada = value != null
                        ? int.parse(value)
                        : 1;
                  });
                },
              ),

              const SizedBox(height: 16),
              // Status (Switch)
              SwitchListTile(
                title: const Text('Produto Ativo'),
                value: _status == 1,
                onChanged: (value) {
                  setState(() => _status = value ? 1 : 0);
                },
              ),

              const SizedBox(height: 16.0),

              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    _cadastrarProduto();
                  },

                  child: _carregando
                      ? const CircularProgressIndicator()
                      : Text(
                          isEdicao ? 'Atualizar' : 'Cadastrar',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
