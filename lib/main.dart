import 'package:cryptoquote/page/moedas_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CryptoQuote());
}

class CryptoQuote extends StatelessWidget {
  const CryptoQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoedasBase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
      ),
      home: const MoedasPage(),
    );
  }
}
