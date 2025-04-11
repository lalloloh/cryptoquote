import 'package:sqflite/sqflite.dart';

class ContaHelper {
  static String get contaDDL => '''
    CREATE TABLE $_tableName(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_saldo REAL
    );
  ''';

  static String get contaDropTable => '''
    DROP TABLE IF EXISTS $_tableName;
  ''';

  static String get _tableName => 'conta';
  static String get _id => 'id';
  static String get _saldo => 'saldo';

  static Future<void> save(DatabaseExecutor db,
      {required double saldo, int? id}) async {
    List<Map<String, dynamic>> queryResult = id != null
        ? await db.query(_tableName,
            where: '$_id = ?', whereArgs: [id], limit: 1)
        : List.empty();

    if (queryResult.isEmpty) {
      await db.insert(_tableName, {_saldo: saldo});
    } else {
      await db.update(_tableName, {_saldo: saldo},
          where: '$_id = ?', whereArgs: [id]);
    }
  }

  static Future<double?> getSaldoById(DatabaseExecutor db, int id) async {
    List<Map<String, dynamic>> queryResult = await db.query(_tableName,
        where: '$_id = ?', whereArgs: [id], limit: 1);

    if (queryResult.isEmpty) {
      return null;
    } else {
      return queryResult.first[_saldo];
    }
  }
}
