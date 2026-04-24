import 'package:flutter/material.dart';
import 'package:aula02/screen/homeScreen.dart';
import 'package:aula02/login.dart';
import 'package:aula02/services/session_service.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SessionService().estaLogado(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(), //mostra na tela o carregamento e assim que terminar vai ser o else
            ),
          );
        }
        return snapshot.data! ? const Homescreen() : const Login();
      },
    );
  }
}
