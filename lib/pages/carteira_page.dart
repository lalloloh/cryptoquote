import 'package:cryptoquote/configs/app_settings.dart';
import 'package:cryptoquote/models/posicao.dart';
import 'package:cryptoquote/repositories/conta_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CarteiraPage extends StatefulWidget {
  const CarteiraPage({super.key});

  @override
  State<CarteiraPage> createState() => _CarteiraPageState();
}

class _CarteiraPageState extends State<CarteiraPage> {
  int index = 0;
  double totalCarteira = 0;
  late NumberFormat currencyFormatter;
  late ContaRepository contaRepository;
  List<CarteiraItem> carteira = [];
  String graficoLabel = '';
  double graficoValor = 0;

  void setGraficoDados(int index) {
    if (index < 0) {
      return;
    } else if (index == carteira.length) {
      graficoLabel = 'Saldo';
      graficoValor = contaRepository.saldo;
    } else {
      graficoLabel = carteira[index].moeda.nome;
      graficoValor = carteira[index].moeda.preco * carteira[index].quantidade;
    }
  }

  List<PieChartSectionData> loadCarteira() {
    setGraficoDados(index);
    carteira = contaRepository.carteira;
    final tamanhoLista = carteira.length + 1;

    return List.generate(
      tamanhoLista,
      (index) {
        final isTouched = index == this.index;
        final isSaldo = index == tamanhoLista - 1;
        final fontSize = isTouched ? 18.0 : 14.0;
        final radius = isTouched ? 60.0 : 50.0;
        final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

        double porcentagem = 0;
        if (!isSaldo) {
          porcentagem =
              (carteira[index].moeda.preco * carteira[index].quantidade) /
                  totalCarteira;
        } else {
          porcentagem = (contaRepository.saldo > 0)
              ? contaRepository.saldo / totalCarteira
              : 0;
        }
        porcentagem *= 100;

        return PieChartSectionData(
          color: color,
          value: porcentagem,
          title: '${porcentagem.toStringAsFixed(0)}%',
          radius: radius,
          titleStyle: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(fontSize: fontSize, color: Colors.black87),
        );
      },
    );
  }

  Widget loadGrafico() {
    if (contaRepository.saldo <= 0) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                sectionsSpace: 5,
                centerSpaceRadius: 110,
                sections: loadCarteira(),
                pieTouchData: PieTouchData(
                  touchCallback: (_, touch) => setState(() {
                    if (touch != null && touch.touchedSection != null) {
                      index = touch.touchedSection!.touchedSectionIndex;
                    }
                    setGraficoDados(index);
                  }),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                graficoLabel,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20, color: Colors.teal),
              ),
              Text(
                currencyFormatter.format(graficoValor),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.black),
              ),
            ],
          )
        ],
      );
    }
  }

  void setTotalCarteira() {
    final carteriaList = contaRepository.carteira;
    setState(() {
      totalCarteira = contaRepository.saldo;
      for (var posicao in carteriaList) {
        totalCarteira += posicao.moeda.preco * posicao.quantidade;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var localeMap = Provider.of<AppSettings>(context).localeMap;
    currencyFormatter = NumberFormat.currency(
        locale: localeMap['locale'], name: localeMap['name']);
    contaRepository = Provider.of<ContaRepository>(context);
    setTotalCarteira();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Valor da Carteira',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Text(
              currencyFormatter.format(totalCarteira),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w700, letterSpacing: -1.5),
            ),
            loadGrafico(),
          ],
        ),
      ),
    );
  }
}
