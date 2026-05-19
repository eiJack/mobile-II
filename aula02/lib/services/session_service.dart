import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  // --------------- token -----------------
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

  // ---------------- usuario ----------------

  Future<void> salvarUsuario(String usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("usuario", usuario);
  }

  Future<String> obterUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("usuario") ?? '';
  }

  Future<void> limparUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario');
  }
}
