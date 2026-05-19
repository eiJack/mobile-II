import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aula02/services/session_service.dart';

class AuthService {
  static const String _baseUrl = "https://api.liliaborges.com.br/api/auth";

  Future<String> login(String email, String senha) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": senha}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> dados = jsonDecode(response.body);

      // 1. Salva o token com shared_preferences (adicionado await para garantir a gravação)
      final token = dados['access_token'].toString();
      await SessionService().salvarToken(token);

      // 2. Chama a nova função GET para buscar os dados reais do usuário
      await _buscarESalvarUsuario(token);

      return token;
    }
    return '';
  }

  // Função interna que faz o GET na rota /me usando o token obtido no login
  Future<void> _buscarESalvarUsuario(String token) async {
    final url = Uri.parse('$_baseUrl/me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Envia o token no cabeçalho de autorização
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print("Dados do perfil recebidos da API: ${response.body}");

        // Salva a String direta do JSON do usuário no SharedPreferences
        await SessionService().salvarUsuario(response.body);
      } else {
        print(
          "Erro ao buscar dados do usuário. Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Erro na requisição do perfil (/me): $e");
    }
  }
}
