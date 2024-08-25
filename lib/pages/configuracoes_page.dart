import 'package:cryptoquote/configs/app_settings.dart';
import 'package:cryptoquote/repositories/conta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => ConfiguracoesPageState();
}

class ConfiguracoesPageState extends State<ConfiguracoesPage> {
  void updateSaldo(ContaRepository contaRepository) async {
    final formKey = GlobalKey<FormState>();
    final valorController = TextEditingController();

    valorController.text = contaRepository.saldo.toString();

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Atualizar o Saldo'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: valorController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Informe o valor do saldo';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState != null &&
                formKey.currentState!.validate()) {
              contaRepository.setSaldo(double.parse(valorController.text));
              Navigator.pop(context);
            }
          },
          child: const Text('Salvar'),
        )
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    final localeMap = Provider.of<AppSettings>(context).localeMap;
    NumberFormat currencyFormatter = NumberFormat.currency(
        locale: localeMap['locale'], name: localeMap['name']);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      appBar: AppBar(centerTitle: true, title: const Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Consumer<ContaRepository>(
          builder: (context, contaRepository, child) {
            return Column(
              children: [
                ListTile(
                  title: const Text('Saldo'),
                  subtitle: Text(
                    currencyFormatter.format(contaRepository.saldo),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  trailing: IconButton(
                    onPressed: () => updateSaldo(contaRepository),
                    icon: const Icon(Icons.edit),
                  ),
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
