import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<String> obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? '';
  }

  Future<bool> estaLogado() async {
    final token = await obterToken();
    return token != '' ? true : false;
  }

  Future<void> limparToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
