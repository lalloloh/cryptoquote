import 'package:cryptoquote/page/favoritas_page.dart';
import 'package:cryptoquote/page/moedas_page.dart';
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
          MoedasPage(),
          FavoritasPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.list_outlined),
              selectedIcon: Icon(Icons.list),
              label: 'Todas'),
          NavigationDestination(
            icon: Icon(Icons.star_outlined),
            selectedIcon: Icon(Icons.star),
            label: 'Favoritas',
          ),
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
