import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppSettings extends ChangeNotifier {
  late Box box;
  Map<String, String> localeMap = {};

  AppSettings() {
    _startSettings();
  }

  void _startSettings() async {
    await _starPreferences();
    _readLocale();
  }

  Future<void> _starPreferences() async {
    box = await Hive.openBox('preferencias');
  }

  void _readLocale() {
    final locale = box.get('locale') ?? 'pt_BR';
    final name = box.get('name') ?? 'R\$';
    localeMap = {
      'locale': locale,
      'name': name,
    };
    notifyListeners();
  }

  setLocale({required String locale, required String name}) async {
    await box.put('locale', locale);
    await box.put('name', name);
    _readLocale();
  }
}
