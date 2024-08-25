import 'package:cryptoquote/pages/carteira_page.dart';
import 'package:cryptoquote/pages/configuracoes_page.dart';
import 'package:cryptoquote/pages/favoritas_page.dart';
import 'package:cryptoquote/pages/moedas_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;
  late PageController pageController;

  setPage(index) {
    setState(() {
      page = index;
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: setPage,
        children: const [
          MoedaPage(),
          FavoritaPage(),
          CarteiraPage(),
          ConfiguracaoPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Todas',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outlined),
            selectedIcon: Icon(Icons.star),
            label: 'Favoritas',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet_outlined),
            selectedIcon: Icon(Icons.wallet),
            label: 'Carteira',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Configurações',
          )
        ],
        selectedIndex: page,
        onDestinationSelected: (index) {
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
}
