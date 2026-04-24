import 'package:flutter/material.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  // Informações da loja (exemplo)
  String nomeLoja = "Loja Exemplo";
  String email = "contato@lojaexemplo.com";
  String telefone = "(11) 98765-4321";
  String endereco = "Rua Exemplo, 123, Cidade, Estado";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove botão de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto ou logo da loja
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.store, size: 50, color: Colors.white),
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
              subtitle: Text(email),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Telefone"),
              subtitle: Text(telefone),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Endereço"),
              subtitle: Text(endereco),
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
