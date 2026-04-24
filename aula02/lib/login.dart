//digitar st e depois dar enter
//ctrl + ; -> comenta
//email: adm@adm.com
//senha: senha123

// import 'package:aula02/formulario.dart';
import 'package:aula02/screen/homeScreen.dart';
import 'package:aula02/services/auth_service.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ----------variaves e funções ------------
  final _email = TextEditingController();
  final _senha = TextEditingController();

  //funcao assincrona precisa aguardar a resposta async await
  bool _carregando = false;

  final _authService = AuthService();

  Future<void> _login() async {
    setState(() {
      //alterar estado
      _carregando = true;
    });
    final token = await _authService.login(_email.text, _senha.text);
    setState(() {
      _carregando = false;
    });
    if (token != '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Homescreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Email ou senha incorreta")));
    }
  }

  //------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
        ),
        //centralizar a tela
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
            //card do login
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("images/cat-avatar.png", width: 56, height: 56),
                    SizedBox(height: 12),
                    Text(
                      "Seja bem-vindo ao meu sistema",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),

                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: Text("Email"),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    SizedBox(height: 12),

                    TextField(
                      controller: _senha,
                      decoration: InputDecoration(
                        label: Text("senha"),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.only(bottom: 16, top: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => {_carregando ? null : _login()},
                        child: _carregando
                            ? CircularProgressIndicator()
                            : Text("Entrar"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
