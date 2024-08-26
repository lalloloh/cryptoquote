import 'package:cryptoquote/configs/app_settings.dart';
import 'package:cryptoquote/models/moeda.dart';
import 'package:cryptoquote/repositories/conta_repository.dart';
import 'package:cryptoquote/widgets/expanded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasDetalhePage extends StatefulWidget {
  final Moeda moeda;

  const MoedasDetalhePage({super.key, required this.moeda});

  @override
  State<MoedasDetalhePage> createState() => _MoedasDetalhePageState();
}

class _MoedasDetalhePageState extends State<MoedasDetalhePage> {
  late NumberFormat currencyFormatter;
  late ContaRepository contaRepository;
  late Map<String, String> localeMap;
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  late double quantidade;

  buy() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await contaRepository
          .comprar(widget.moeda, double.parse(_valorController.text))
          .then(
        (_) {
          if (mounted) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compra realizada com sucesso!')));
          }
        },
      );
    }
  }

  void loadProviders() {
    localeMap = Provider.of<AppSettings>(context).localeMap;
    currencyFormatter = NumberFormat.currency(
        locale: localeMap['locale'], name: localeMap['name']);

    contaRepository = Provider.of<ContaRepository>(context, listen: false);
  }

  @override
  void initState() {
    quantidade = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadProviders();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.moeda.nome),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        iconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 50,
                      child: Image.asset(widget.moeda.icone),
                    ),
                  ),
                  Text(
                    currencyFormatter.format(widget.moeda.preco),
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ],
              ),
            ),
            quantidade > 0
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.05)),
                          child: Text(
                            '$quantidade ${widget.moeda.sigla}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.teal,
                                  fontSize: 20,
                                ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _valorController,
                style: Theme.of(context).textTheme.titleLarge,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor da compra';
                  } else if (double.parse(value) < 50) {
                    return 'O valor mínimo para compra é R\$50,00';
                  } else if (double.parse(value) > contaRepository.saldo) {
                    return 'Você não tem saldo suficiente';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    quantidade = value.isEmpty
                        ? 0
                        : double.parse(value) / widget.moeda.preco;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle: Theme.of(context).textTheme.labelLarge,
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  prefixIconColor: Theme.of(context).colorScheme.primary,
                  suffix: Text(
                    'reais',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: ExpandedButton(
                icon: Icons.check,
                label: 'Comprar',
                onPressed: buy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
