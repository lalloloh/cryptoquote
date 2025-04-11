import 'package:cryptoquote/models/moeda.dart';

class Historico {
  late int id;
  late DateTime dataOperacao;
  String tipoOperacao;
  Moeda moeda;
  double valor;
  double quantidade;

  Historico({
    id,
    dataOperacao,
    required this.tipoOperacao,
    required this.moeda,
    required this.valor,
    required this.quantidade,
  }) {
    this.id = id ?? 0;
    this.dataOperacao = dataOperacao ?? DateTime.now();
  }

  factory Historico.fromLocalDataBaseMap(Map<String, dynamic> map) {
    return Historico(
      id: map['id'],
      dataOperacao: DateTime.fromMillisecondsSinceEpoch(map['data_operacao']),
      tipoOperacao: map['tipo_operacao'],
      moeda: Moeda.fromSigla(map['sigla']),
      valor: map['valor'],
      quantidade: double.parse(map['quantidade']),
    );
  }
}
