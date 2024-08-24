import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        textTheme: TextTheme(
          labelLarge: const TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0,
          ),
          headlineMedium: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
            fontSize: 28,
          ),
          titleSmall: const TextStyle(
            color: Colors.indigo,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          backgroundColor: Colors.indigo,
          accentColor: Colors.indigoAccent,
        ),
      );
}
