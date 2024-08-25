import 'package:cryptoquote/models/moeda.dart';
import 'package:cryptoquote/pages/moedas_detalhe_page.dart';
import 'package:cryptoquote/repositories/favoritas_repository.dart';
import 'package:cryptoquote/widgets/moeda_card.dart';
import 'package:cryptoquote/widgets/sliver_appbar_selection_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class FavoritaPage extends StatefulWidget {
  const FavoritaPage({super.key});

  @override
  State<FavoritaPage> createState() => _FavoritaPageState();
}

class _FavoritaPageState extends State<FavoritaPage>
    with TickerProviderStateMixin {
  bool selectionMode = false;
  bool showFloatingActionButton = false;
  List<Moeda> selectedItens = [];
  late final AnimationController _animationController;
  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  ScaleTransition? floatingActionButton() {
    if (selectedItens.isNotEmpty) {
      _animationController.forward();
      return ScaleTransition(
        scale: _animation,
        child: FloatingActionButton.extended(
          onPressed: () {
            Provider.of<FavoritasRepository>(context, listen: false)
                .removeAll(selectedItens);
            clearSelectedItens();
          },
          icon: const Icon(Icons.remove_circle_outline),
          label: Text(
            'REMOVER',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      );
    } else {
      return null;
    }
  }

  void clearSelectedItens() {
    setState(() {
      selectionMode = false;
      selectedItens.clear();
    });
  }

  showDetails(Moeda moeda) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoedasDetalhePage(moeda: moeda),
      ),
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !selectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          clearSelectedItens();
        }
      },
      child: Scaffold(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            Consumer<FavoritasRepository>(
              builder: (context, favoritasRepository, child) {
                return SliverAppbarSelectionMode(
                  onSelectionMode: selectionMode,
                  title: const Text('Moedas Favoritas'),
                  titleOnSelectionMode:
                      Text('${selectedItens.length} selecionadas'),
                  leadingOnSelectionMode: BackButton(
                    onPressed: () {
                      clearSelectedItens();
                    },
                  ),
                  actionsOnSelectionMode: [
                    Checkbox(
                      value: favoritasRepository.lista.every((moeda) =>
                          selectedItens
                              .any((selectedItem) => moeda == selectedItem)),
                      onChanged: (value) {
                        if (value != null && value) {
                          setState(() {
                            selectedItens.clear();
                            selectedItens.addAll(favoritasRepository.lista);
                          });
                        } else if (value != null && !value) {
                          setState(() {
                            selectedItens.clear();
                          });
                        }
                      },
                    )
                  ],
                );
              },
            )
          ],
          body: Consumer<FavoritasRepository>(
            builder: (context, favoritasRepository, child) {
              return favoritasRepository.lista.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Ainda não há moedas favoritas!'),
                      ),
                    )
                  : NotificationListener<UserScrollNotification>(
                      onNotification: (scroll) {
                        if (scroll.direction == ScrollDirection.reverse &&
                            selectionMode &&
                            showFloatingActionButton) {
                          _animationController.reverse();
                          showFloatingActionButton = false;
                        } else if (scroll.direction ==
                                ScrollDirection.forward &&
                            selectionMode &&
                            !showFloatingActionButton) {
                          _animationController.forward();
                          showFloatingActionButton = true;
                        }
                        return true;
                      },
                      child: ListView.builder(
                        itemCount: favoritasRepository.lista.length,
                        itemBuilder: (context, index) {
                          bool selected = selectedItens
                              .contains(favoritasRepository.lista[index]);

                          return Dismissible(
                            key: Key(favoritasRepository.lista[index].sigla),
                            direction: selectionMode
                                ? DismissDirection.none
                                : DismissDirection.endToStart,
                            onDismissed: (direction) => favoritasRepository
                                .removeAll([favoritasRepository.lista[index]]),
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: MoedaCard(
                                moeda: favoritasRepository.lista[index],
                                selected: selected,
                                onTap: () {
                                  if (!selectionMode) {
                                    showDetails(
                                        favoritasRepository.lista[index]);
                                  } else {
                                    setState(() {
                                      selected
                                          ? selectedItens.remove(
                                              favoritasRepository.lista[index])
                                          : selectedItens.add(
                                              favoritasRepository.lista[index]);

                                      if (selectedItens.isEmpty) {
                                        selectionMode = false;
                                      }
                                    });
                                  }
                                },
                                onLongPress: () {
                                  setState(() {
                                    if (!selectionMode) {
                                      selectionMode = true;
                                      _animationController.forward();
                                      showFloatingActionButton = true;
                                    }
                                    if (!selectedItens.contains(
                                        favoritasRepository.lista[index])) {
                                      selectedItens.add(
                                          favoritasRepository.lista[index]);
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: floatingActionButton(),
      ),
    );
  }
}
