import 'package:cryptoquote/configs/app_settings.dart';
import 'package:cryptoquote/models/moeda.dart';
import 'package:cryptoquote/pages/moedas_detalhe_page.dart';
import 'package:cryptoquote/repositories/favoritas_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedaCard extends StatefulWidget {
  final Moeda moeda;
  const MoedaCard({super.key, required this.moeda});

  @override
  State<MoedaCard> createState() => _MoedaCardState();
}

class _MoedaCardState extends State<MoedaCard> {
  late NumberFormat currencyFormatter;
  late Map<String, String> localeMap;

  showDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoedasDetalhePage(moeda: widget.moeda),
      ),
    );
  }

  void readNumberFormat() {
    localeMap = Provider.of<AppSettings>(context).localeMap;
    currencyFormatter = NumberFormat.currency(
        locale: localeMap['locale'], name: localeMap['name']);
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();

    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => showDetails(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(child: Image.asset(widget.moeda.icone))),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.moeda.nome,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        widget.moeda.sigla,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.black45),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  currencyFormatter.format(widget.moeda.preco),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: ListTile(
                    title: const Text('Remover das Favoritas'),
                    onTap: () {
                      Navigator.pop(context);
                      Provider.of<FavoritasRepository>(context, listen: false)
                          .remove(widget.moeda);
                    },
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
