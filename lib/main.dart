import 'package:cryptoquote/configs/app_settings.dart';
import 'package:cryptoquote/configs/hive_config.dart';
import 'package:cryptoquote/pages/home_page.dart';
import 'package:cryptoquote/repositories/favoritas_repository.dart';
import 'package:cryptoquote/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
        ChangeNotifierProvider(create: (context) => AppSettings())
      ],
      child: const CryptoQuote(),
    ),
  );
}

class CryptoQuote extends StatelessWidget {
  const CryptoQuote({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoedasBase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
