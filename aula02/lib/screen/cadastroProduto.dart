import 'package:aula02/model/produto.dart';
import 'package:aula02/services/produtos_service.dart';
import 'package:aula02/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:aula02/screen/leitorCodigoBarras.dart';
import 'package:aula02/widgets/seletor_imagem.dart';
import 'dart:io';

class cadastroProduto extends StatefulWidget {
  const cadastroProduto({super.key});

  @override
  State<cadastroProduto> createState() => _cadastroProdutoState();
}

class _cadastroProdutoState extends State<cadastroProduto> {
  File? _imagemAtual;
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _codigoBarrasController = TextEditingController();
  final _service = ProdutosService();

  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  final _sevice = ProdutosService();
  //-------------------------------------------------------------
  void _cadastrarProduto() async {
    String token = await SessionService().obterToken();
    int idCategoria = int.tryParse(_categoriaController.text) ?? 0;
    Produto produto = Produto(
      nome: _nomeController.text,
      codigoBarras: _codigoBarrasController.text,
      categoria: idCategoria,
      marca: _nomeController.text,
      imagem: _imagemAtual != null ? _imagemAtual!.path : '',
      status: 0,
    );

    final resultado = await _service.cadastrarProduto(token, produto);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(resultado)));
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
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              //---------------------------------------
              //criar campos
              //'codigo_barras': LeitorCódigoBarras
              //'nome': TextFormField
              //'categoria_id': DropdownButtonFormField
              //'descricao': TextFormField não obrigatorio
              //'imagem': SelecionarImagens não obrigatorio
              //'marca': TextFormField não obrigatorio
              //'peso': TextFormField não obrigatório
              //sao iguais ao textformfield do codigo de barras
              //---------------------------------------

              //imagem
              SeletorImagem(
                imagemAtual: _imagemAtual,
                quandoImagemSelecionada: (img) {
                  setState(() {
                    _imagemAtual = img;
                  });
                },
              ),

              TextFormField(
                controller: _codigoBarrasController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: TextButton(
                    onPressed: _lerCodigoBarras,
                    child: Icon(Icons.qr_code_scanner),
                  ),
                  labelText: 'Codigo de Barras',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              //-------------------------------
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Titulo do produto',
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 8),
              //---------------------------------
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Descrição do produto',
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 8),
              //---------------------------------
              DropdownButtonFormField(
                onChanged: (value) => {},
                items: [
                  DropdownMenuItem(value: '1', child: Text("Laticinios")),
                  DropdownMenuItem(value: '2', child: Text("Chocolate")),
                  DropdownMenuItem(value: '3', child: Text("Mercearia")),
                  DropdownMenuItem(value: '4', child: Text("Açougue")),
                ],
                initialValue: '1',
                decoration: InputDecoration(labelText: 'Categoria'),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _cadastrarProduto();
                  },
                  child: Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
