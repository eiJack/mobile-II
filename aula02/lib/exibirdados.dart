import 'package:flutter/material.dart';

class Exibirdados extends StatefulWidget {
  String nome;
  String email;
  String senha;
  bool politica;
  bool termos;
  double slider;
  String opcao;

  Exibirdados({
    super.key,
    String this.nome = "",
    String this.email = "",
    String this.senha = "",
    bool this.politica = false,
    bool this.termos = false,
    double this.slider = 0,
    String this.opcao = "",
  });

  @override
  State<Exibirdados> createState() => _ExibirdadosState();
}

class _ExibirdadosState extends State<Exibirdados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Exibindo dados",
          style: TextStyle(color: Colors.blue, fontSize: 24),
        ),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Nome: ${widget.nome}'),
            Text('Email: ${widget.email}'),
            Text('Senha: ${widget.senha}'),
          ],
        ),
      ),
    );
  }
}
