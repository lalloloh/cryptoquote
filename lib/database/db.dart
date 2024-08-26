import 'dart:async';

import 'package:cryptoquote/database/resources/carteira_helper.dart';
import 'package:cryptoquote/database/resources/conta_helper.dart';
import 'package:cryptoquote/database/resources/historico_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  static Database? _database;

  Future<Database> get dataBase async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), 'cryptoquote.db'),
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await _createTables(db);
    await ContaHelper.save(db, saldo: 0);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await _dropTables(db);
      await _createTables(db);
      await ContaHelper.save(db, saldo: 0);
    }
  }

  Future<void> _createTables(Database db) async {
    await db.execute(ContaHelper.contaDDL);
    await db.execute(HistoricoHelper.historicoDDL);
    await db.execute(CarteiraHelper.carteiraDDL);
  }

  Future<void> _dropTables(Database db) async {
    await db.execute(ContaHelper.contaDropTable);
    await db.execute(HistoricoHelper.historicoDropTable);
    await db.execute(CarteiraHelper.carteiraDropTable);
  }
}
