import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:aula02/services/session_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  // Informações da loja/usuario logado
  String nomeLoja = "";
  String email = "";
  String telefone = "";
  String endereco = "";
  bool carregando = true;

  //carregar usuario
  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  //carregar usuario
  Future<void> carregarUsuario() async {
    try {
      final usuarioString = await SessionService().obterUsuario();

      print(usuarioString);

      if (usuarioString.isNotEmpty) {
        final usuario = jsonDecode(usuarioString);

        setState(() {
          nomeLoja = usuario['name'] ?? '';
          email = usuario['email'] ?? '';
          carregando = false;
        });
      } else {
        setState(() {
          carregando = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove botão de voltar
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto ou logo da loja
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: const NetworkImage('https://loremflickr.com/200/200/kitten',),
            ),
            const SizedBox(height: 16),
            Text(
              nomeLoja,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Informações da loja
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: Text(email.isEmpty ? "Não informado" : email),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Telefone"),
              subtitle: Text(telefone.isEmpty ? "Não informado" : telefone),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Endereço"),
              subtitle: Text(endereco.isEmpty ? "Não informado" : endereco),
            ),
            const Spacer(),
            // Botão de editar perfil
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ação de editar perfil
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Editar perfil clicado")),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Editar Perfil"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
