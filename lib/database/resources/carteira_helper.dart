import 'package:cryptoquote/models/posicao.dart';
import 'package:cryptoquote/repositories/moeda_repository.dart';
import 'package:sqflite/sqflite.dart';

class CarteiraHelper {
  static String get carteiraDDL => '''
    CREATE TABLE $_tableName(
      $_sigla TEXT PRIMARY KEY,
      $_moeda TEXT,
      $_quantidade TEXT
    );
  ''';

  static String get carteiraDropTable => '''
    DROP TABLE IF EXISTS $_tableName;
  ''';

  static String get _tableName => 'carteira';
  static String get _sigla => 'sigla';
  static String get _moeda => 'moeda';
  static String get _quantidade => 'quantidade';

  static Future<void> save(DatabaseExecutor db, CarteiraItem item) async {
    List<Map<String, dynamic>> queryResult = await db.query(
      _tableName,
      where: '$_sigla = ?',
      whereArgs: [item.moeda.sigla],
    );

    if (queryResult.isEmpty) {
      await db.insert(_tableName, {
        _sigla: item.moeda.sigla,
        _moeda: item.moeda.nome,
        _quantidade: item.quantidade.toString(),
      });
    } else {
      await db.update(
        _tableName,
        {
          _quantidade:
              (item.quantidade + double.parse(queryResult.first[_quantidade]))
                  .toString(),
        },
        where: '$_sigla = ?',
        whereArgs: [item.moeda.sigla],
      );
    }
  }

  static Future<List<CarteiraItem>> getAll(DatabaseExecutor db) async {
    List<Map<String, dynamic>> queryResult = await db.query(_tableName);

    List<CarteiraItem> retorno = List.empty(growable: true);
    for (var result in queryResult) {
      retorno.add(CarteiraItem(
          moeda: MoedaRepository.tabela.firstWhere(
            (moeda) => moeda.sigla == result[_sigla],
          ),
          quantidade: double.parse(result[_quantidade])));
    }

    return retorno;
  }
}
