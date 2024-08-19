import 'package:cryptoquote/model/moeda.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MoedasDetalhePage extends StatefulWidget {
  final Moeda moeda;

  const MoedasDetalhePage({super.key, required this.moeda});

  @override
  State<MoedasDetalhePage> createState() => _MoedasDetalhePageState();
}

class _MoedasDetalhePageState extends State<MoedasDetalhePage> {
  final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  late double quantidade;

  buy() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Salvar a compra

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compra realizada com sucesso!')));
    }
  }

  @override
  void initState() {
    quantidade = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o valor da compra';
                  } else if (double.parse(value) < 50) {
                    return 'O valor mínimo para compra é R\$50,00';
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
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: buy,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Comprar',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                              ),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
