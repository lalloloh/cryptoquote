import 'package:cryptoquote/configs/app_settings.dart';
import 'package:cryptoquote/models/moeda.dart';
import 'package:cryptoquote/pages/moedas_detalhe_page.dart';
import 'package:cryptoquote/repositories/favoritas_repository.dart';
import 'package:cryptoquote/repositories/moeda_repository.dart';
import 'package:cryptoquote/widgets/sliver_appbar_selection_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedaPage extends StatefulWidget {
  const MoedaPage({super.key});

  @override
  State<MoedaPage> createState() => _MoedaPageState();
}

class _MoedaPageState extends State<MoedaPage> with TickerProviderStateMixin {
  late List<Moeda> table;
  late Map<String, String> localeMap;
  late NumberFormat currencyFormatter;
  late List<Moeda> selectedItens;
  late bool selectionMode;
  late bool showFloatingActionButton;

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
                .saveAll(selectedItens);
            clearSelectedItens();
          },
          icon: const Icon(Icons.star),
          label: Text(
            'FAVORITAR',
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

  void showDetails(Moeda moeda) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoedasDetalhePage(moeda: moeda),
      ),
    );
  }

  void readNumberFormat() {
    localeMap = Provider.of<AppSettings>(context).localeMap;
    currencyFormatter = NumberFormat.currency(
        locale: localeMap['locale'], name: localeMap['name']);
  }

  PopupMenuButton switchAppLanguageButton() {
    final locale = localeMap['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = localeMap['name'] == 'R\$' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            Provider.of<AppSettings>(context, listen: false).setLocale(
              locale: locale,
              name: name,
            );
          },
          child: ListTile(
            leading: const Icon(Icons.swap_vert),
            title: Text('Usar valores em $name'),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    table = MoedaRepository.tabela;
    selectedItens = List.empty(growable: true);
    selectionMode = false;
    showFloatingActionButton = true;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();

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
            SliverAppbarSelectionMode(
              onSelectionMode: selectionMode,
              title: const Text('Cripto Moedas'),
              titleOnSelectionMode:
                  Text('${selectedItens.length} selecionadas'),
              leadingOnSelectionMode: BackButton(
                onPressed: () {
                  clearSelectedItens();
                },
              ),
              actions: [
                switchAppLanguageButton(),
              ],
              actionsOnSelectionMode: [
                Checkbox(
                  value: table.every((moeda) => selectedItens
                      .any((selectedItem) => moeda == selectedItem)),
                  onChanged: (value) {
                    if (value != null && value) {
                      setState(() {
                        selectedItens.clear();
                        selectedItens.addAll(table);
                      });
                    } else if (value != null && !value) {
                      setState(() {
                        selectedItens.clear();
                      });
                    }
                  },
                )
              ],
            ),
          ],
          body: NotificationListener<UserScrollNotification>(
            onNotification: (scroll) {
              if (scroll.direction == ScrollDirection.reverse &&
                  selectionMode &&
                  showFloatingActionButton) {
                _animationController.reverse();
                showFloatingActionButton = false;
              } else if (scroll.direction == ScrollDirection.forward &&
                  selectionMode &&
                  !showFloatingActionButton) {
                _animationController.forward();
                showFloatingActionButton = true;
              }
              return true;
            },
            child: Consumer<FavoritasRepository>(
              builder: (context, favoritasRepository, child) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int coin) {
                    final selected = selectedItens.contains(table[coin]);

                    return ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      leading: CircleAvatar(
                        backgroundColor: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        child: selected
                            ? const Icon(Icons.check)
                            : ClipRRect(child: Image.asset(table[coin].icone)),
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              table[coin].nome,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: selected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null),
                            ),
                          ),
                          const Spacer(),
                          if (favoritasRepository.lista
                              .any((fav) => fav.sigla == table[coin].sigla))
                            const Flexible(
                              flex: 2,
                              child: Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                      trailing: Text(
                        currencyFormatter.format(table[coin].preco),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: selected
                                    ? Theme.of(context).colorScheme.primary
                                    : null),
                      ),
                      selected: selected,
                      selectedTileColor:
                          Theme.of(context).colorScheme.primary.withAlpha(50),
                      onTap: () {
                        if (selectionMode) {
                          setState(() {
                            selected
                                ? selectedItens.remove(table[coin])
                                : selectedItens.add(table[coin]);

                            if (selectedItens.isEmpty) {
                              selectionMode = false;
                            }
                          });
                        } else {
                          showDetails(table[coin]);
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          if (!selectionMode) {
                            selectionMode = true;
                            _animationController.forward();
                            showFloatingActionButton = true;
                          }
                          if (!selectedItens.contains(table[coin])) {
                            selectedItens.add(table[coin]);
                          }
                        });
                      },
                    );
                  },
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => Divider(
                    color: Colors.grey[200],
                  ),
                  itemCount: table.length,
                );
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: floatingActionButton(),
      ),
    );
  }
}
