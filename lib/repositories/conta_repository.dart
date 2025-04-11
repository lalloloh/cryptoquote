import 'package:cryptoquote/database/db.dart';
import 'package:cryptoquote/database/resources/carteira_helper.dart';
import 'package:cryptoquote/database/resources/conta_helper.dart';
import 'package:cryptoquote/database/resources/historico_helper.dart';
import 'package:cryptoquote/models/enums/enum_tipo_operacao.dart';
import 'package:cryptoquote/models/historico.dart';
import 'package:cryptoquote/models/moeda.dart';
import 'package:cryptoquote/models/posicao.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  List<CarteiraItem> _carteira = [];
  List<Historico> _historico = [];
  double _saldo = 0;

  double get saldo => _saldo;
  List<CarteiraItem> get carteira => _carteira;
  List<Historico> get historico => _historico;

  ContaRepository() {
    _startRepository();
  }

  Future<void> _startRepository() async {
    await _getSaldo();
    await _getCarteira();
    await _getHistorico();
  }

  Future<void> _getSaldo() async {
    db = await DB.instance.dataBase;
    final obtainedSaldo = await ContaHelper.getSaldoById(db, 1);
    if (obtainedSaldo != null) _saldo = obtainedSaldo;
    notifyListeners();
  }

  Future<void> setSaldo(double valor) async {
    db = await DB.instance.dataBase;
    await ContaHelper.save(db, saldo: valor, id: 1);
    _saldo = valor;
    notifyListeners();
  }

  Future<void> comprar(Moeda moeda, double valor) async {
    db = await DB.instance.dataBase;
    await db.transaction(
      (txn) async {
        await CarteiraHelper.save(
            txn, CarteiraItem(moeda: moeda, quantidade: (valor / moeda.preco)));

        await HistoricoHelper.save(
          txn,
          Historico(
            tipoOperacao: EnumTipoOperacao.compra,
            moeda: moeda,
            valor: valor,
            quantidade: (valor / moeda.preco),
          ),
        );

        await ContaHelper.save(txn, saldo: saldo - valor, id: 1);
      },
    );
    await _startRepository();
  }

  Future<void> _getCarteira() async {
    _carteira = await CarteiraHelper.getAll(db);
    notifyListeners();
  }

  Future<void> _getHistorico() async {
    _historico = await HistoricoHelper.getAll(db);
    notifyListeners();
  }
}
