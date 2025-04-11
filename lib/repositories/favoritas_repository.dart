import 'dart:collection';

import 'package:cryptoquote/adapters/moeda_hive_adapter.dart';
import 'package:cryptoquote/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoritasRepository extends ChangeNotifier {
  final List<Moeda> _lista = List.empty(growable: true);
  late LazyBox<Moeda> box;

  FavoritasRepository() {
    _startRepository();
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  void saveAll(List<Moeda> moedas) {
    for (var moeda in moedas) {
      if (!_lista.any((m) => m.sigla == moeda.sigla)) {
        box.put(moeda.sigla, moeda);
        _lista.add(moeda);
      }
    }
    notifyListeners();
  }

  void removeAll(List<Moeda> moedas) {
    for (var moeda in moedas) {
      if (_lista.any((m) => m.sigla == moeda.sigla)) {
        box.delete(moeda.sigla);
        _lista.remove(moeda);
      }
    }
    notifyListeners();
  }

  Future<void> _startRepository() async {
    await _openBox();
    await _readFavoritas();
  }

  Future<void> _openBox() async {
    Hive.registerAdapter(MoedaHiveAdapter());
    box = await Hive.openLazyBox<Moeda>('moedas_favoritas');
  }

  Future<void> _readFavoritas() async {
    for (String key in box.keys) {
      Moeda? moeda = await box.get(key);
      if (moeda != null) {
        _lista.add(moeda);
      }
    }
    notifyListeners();
  }
}
