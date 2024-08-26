import 'package:cryptoquote/models/historico.dart';
import 'package:sqflite/sqflite.dart';

class HistoricoHelper {
  static String get historicoDDL => '''
    CREATE TABLE $_tableName(
      $_id INTEGER PRIMARY KEY AUTOINCREMENT,
      $_dataOperacao INTEGER,
      $_tipoOperacao TEXT,
      $_moeda TEXT,
      $_sigla TEXT,
      $_valor REAL,
      $_quantidade TEXT
    );
  ''';

  static String get historicoDropTable => '''
    DROP TABLE IF EXISTS $_tableName;
  ''';

  static String get _tableName => 'historico';
  static String get _id => 'id';
  static String get _dataOperacao => 'data_operacao';
  static String get _tipoOperacao => 'tipo_operacao';
  static String get _moeda => 'moeda';
  static String get _sigla => 'sigla';
  static String get _valor => 'valor';
  static String get _quantidade => 'quantidade';

  static Future<void> save(DatabaseExecutor db, Historico historico) async {
    List<Map<String, dynamic>> queryResult = await db
        .query(_tableName, where: '$_id = ?', whereArgs: [historico.id]);

    if (queryResult.isEmpty) {
      await db.insert(_tableName, {
        _dataOperacao: historico.dataOperacao.millisecondsSinceEpoch,
        _tipoOperacao: historico.tipoOperacao,
        _moeda: historico.nomeMoeda,
        _sigla: historico.siglaMoeda,
        _valor: historico.valor,
        _quantidade: historico.quantidade.toString(),
      });
    } else {
      await db.update(
          _tableName,
          {
            _dataOperacao: historico.dataOperacao.millisecondsSinceEpoch,
            _tipoOperacao: historico.tipoOperacao,
            _moeda: historico.nomeMoeda,
            _sigla: historico.siglaMoeda,
            _valor: historico.valor,
            _quantidade: historico.quantidade.toString(),
          },
          where: '$_id = ?',
          whereArgs: [historico.id]);
    }
  }
}
