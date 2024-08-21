import 'dart:collection';

import 'package:cryptoquote/model/moeda.dart';
import 'package:flutter/material.dart';

class FavoritasRepository extends ChangeNotifier {
  final List<Moeda> _lista = List.empty(growable: true);

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    for (var moeda in moedas) {
      if (!_lista.contains(moeda)) {
        _lista.add(moeda);
      }
    }
    notifyListeners();
  }

  remove(Moeda moeda) {
    _lista.remove(moeda);
    notifyListeners();
  }
}
