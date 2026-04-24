import 'package:flutter/material.dart';
import 'package:aula02/screen/perfilScreen.dart';
import 'package:aula02/screen/produtosScreen.dart';
import 'package:aula02/screen/relatorioScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  //---------------------------------
  // Lista de páginas que correspondem às abas
  @override
  void initState() {
    super.initState();
    _pages = [_homePage(), ProdutosScreen(), RelatorioScreen(), PerfilScreen()];
  }

  //---------------------------------
  Widget _homePage() {
    return SingleChildScrollView();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // aqui o body muda conforme a aba selecionada
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        //mostra o botão do nav que esta selecionado/icone destacado
        currentIndex: _currentIndex,

        //roda quando o usuario muda a aba
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // att o currentIndex, sendo assim só muda o botão selecionado
          });
        },
        //comportamento visual da barra, icone em tamanho fixo -> tem shifting que o selecionado cresce
        type: BottomNavigationBarType.fixed,

        //lista dos itens
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smartphone),
            label: 'Produtos',
            backgroundColor: Colors.deepPurple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Relatorios',
            backgroundColor: Colors.lightBlueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
