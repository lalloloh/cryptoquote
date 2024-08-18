import 'package:cryptoquote/model/moeda.dart';
import 'package:cryptoquote/repository/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  late List<Moeda> table;
  late NumberFormat currencyFormatter;
  late List<Moeda> selectedItens;
  late bool selectionMode;

  appbar() {
    if (selectedItens.isEmpty) {
      return AppBar(
        centerTitle: true,
        title: const Text('Cripto Moedas'),
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      );
    } else {
      return AppBar(
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              setState(() {
                selectionMode = false;
                selectedItens.clear();
              });
            },
          ),
          title: Text('${selectedItens.length} selecionadas'),
          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall);
    }
  }

  floatingActionButton() {
    if (selectedItens.isNotEmpty) {
      return FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.star),
        label: Text(
          'FAVORITAR',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    } else {
      return null;
    }
  }

  @override
  void initState() {
    table = MoedaRepository.tabela;
    currencyFormatter = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
    selectedItens = List.empty(growable: true);
    selectionMode = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !selectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            selectionMode = false;
            selectedItens.clear();
          });
        }
      },
      child: Scaffold(
        appBar: appbar(),
        body: ListView.separated(
          itemBuilder: (BuildContext context, int coin) {
            final selected = selectedItens.contains(table[coin]);

            return ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: CircleAvatar(
                backgroundColor: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                child: selectedItens.contains(table[coin])
                    ? const Icon(Icons.check)
                    : ClipRRect(child: Image.asset(table[coin].icone)),
              ),
              title: Text(
                table[coin].nome,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : null),
              ),
              trailing: Text(
                currencyFormatter.format(table[coin].preco),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                }
              },
              onLongPress: () {
                setState(() {
                  if (!selectionMode) {
                    selectionMode = true;
                  }
                  selectedItens.add(table[coin]);
                });
              },
            );
          },
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => Divider(
            color: Colors.grey[200],
          ),
          itemCount: table.length,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: floatingActionButton(),
      ),
    );
  }
}
