import 'package:cryptoquote/database/db.dart';
import 'package:cryptoquote/models/posicao.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  final List<Posicao> carteira = [];
  double _saldo = 0;

  double get saldo => _saldo;

  ContaRepository() {
    _startRepository();
  }

  Future<void> _startRepository() async {
    await _getSaldo();
  }

  Future<void> _getSaldo() async {
    db = await DB.instance.dataBase;

    List<Map<String, dynamic>> conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }

  Future<void> setSaldo(double valor) async {
    db = await DB.instance.dataBase;
    db.update('conta', {'saldo': valor});
    _saldo = valor;
    notifyListeners();
  }
}
