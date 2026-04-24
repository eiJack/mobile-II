import 'package:flutter/material.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  //------------aqui vai estar as variaveis -------------------
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _descricaoController = TextEditingController();

  bool _aceitaTermos = false;
  bool _politicaPrivacidade = false;
  double _sliderNumber = 0;
  String? _opcao;
  bool _mostrarSenha = true;
  //-----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //cabeçalho do app
      appBar: AppBar(
        automaticallyImplyLeading: false, //remove o botao de voltar
        backgroundColor: Colors.deepPurple,
        title: Text("Formulario de validação"),
        centerTitle: true, // centraliza o titulo
        foregroundColor: Colors.white, // deixa o texto branco
      ),

      body: Container(
        //container para fazer o gradiente do fundo
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
        ),

        child: Padding(
          padding: EdgeInsets.all(20), // espaço para aparecer o degradê

          child: Card(
            // card branco na frente onde fica o formulario
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: SingleChildScrollView(
              //permite o scroll do forms dentro do card
              child: Padding(
                padding: EdgeInsets.all(16),

                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: 60,
                                backgroundImage: AssetImage(
                                  "images/cat-avatar.png",
                                ),
                              ),

                              Container(
                                height: 60,
                                alignment: Alignment.topCenter,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    181,
                                    224,
                                    224,
                                    224,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(60),
                                    bottomRight: Radius.circular(60),
                                  ),
                                ),

                                child: TextButton(
                                  onPressed: () {},
                                  child: Column(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text("Editar"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _nomeController,
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return "Digite um nome válido";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Nome",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _emailController,
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return "Informe um email";
                          }
                          if (!valor.contains("@")) {
                            return "Email inválido";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextFormField(
                        //senha
                        controller: _senhaController,
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return "Informe uma senha";
                          }
                          return null;
                        },
                        obscureText: _mostrarSenha, //ocultar senha
                        // keyboardType para senha geralmente não é emailAddress, mas deixei conforme seu código
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Senha",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _mostrarSenha = !_mostrarSenha; // true / false
                              });
                            },
                            icon: Icon(
                              _mostrarSenha
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      TextFormField(
                        controller: _descricaoController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Descrição",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      //necessita de variavel para mudar o value
                      //serve para aceitar notificacao
                      Checkbox(
                        value: _aceitaTermos,
                        onChanged: (valor) {
                          setState(() {
                            _aceitaTermos = valor!;
                          });
                        },
                        semanticLabel: "Aceitar termos",
                      ),

                      const SizedBox(height: 24),

                      CheckboxListTile(
                        value: _politicaPrivacidade,
                        title: Text("Aceitar politicas de privacidade"),
                        onChanged: (valor) {
                          setState(() {
                            _politicaPrivacidade = valor ?? false;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      ///['Item 1', 'Item 2']
                      DropdownButton(
                        value: _opcao, // Vincula a variável
                        hint: Text("Selecione a turma"),
                        items: [
                          DropdownMenuItem(
                            value: "Turma A",
                            child: Text("Turma A"),
                          ),
                          DropdownMenuItem(
                            value: "Turma B",
                            child: Text("Turma B"),
                          ),
                        ],
                        onChanged: (valor) {
                          setState(() {
                            _opcao = valor.toString();
                          });
                        },
                      ),
                      Text(_opcao ?? ""),
                      const SizedBox(height: 24),

                      Slider(
                        value: _sliderNumber,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: _sliderNumber.round().toString(),
                        onChanged: (valor) {
                          setState(() {
                            _sliderNumber = valor.toDouble();
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botão para salvar (opcional, mas útil num form)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          child: Text("Salvar Dados"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
