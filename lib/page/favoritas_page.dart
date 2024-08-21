import 'package:cryptoquote/repository/favoritas_repository.dart';
import 'package:cryptoquote/widgets/moeda_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritasPage extends StatefulWidget {
  const FavoritasPage({super.key});

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            snap: true,
            floating: true,
            centerTitle: true,
            title: const Text('Moedas Favoritas'),
            backgroundColor: Theme.of(context).primaryColor,
            titleTextStyle: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          )
        ],
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Consumer<FavoritasRepository>(
            builder: (context, favoritasRepository, child) {
              return favoritasRepository.lista.isEmpty
                  ? const ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Ainda não há moedas favoritas!'),
                    )
                  : ListView.builder(
                      itemCount: favoritasRepository.lista.length,
                      itemBuilder: (context, index) {
                        return MoedaCard(
                            moeda: favoritasRepository.lista[index]);
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}
