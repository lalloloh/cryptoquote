import 'package:cryptoquote/models/moeda.dart';

class Historico {
  late int id;
  late DateTime dataOperacao;
  String tipoOperacao;
  late String nomeMoeda;
  late String siglaMoeda;
  double valor;
  double quantidade;

  Historico({
    id,
    dataOperacao,
    required this.tipoOperacao,
    required this.nomeMoeda,
    required this.siglaMoeda,
    required this.valor,
    required this.quantidade,
  }) {
    this.id = id ?? 0;
    this.dataOperacao = dataOperacao ?? DateTime.now();
  }

  Historico.withMoeda({
    id,
    dataOperacao,
    required this.tipoOperacao,
    required Moeda moeda,
    required this.valor,
    required this.quantidade,
  }) {
    this.id = id ?? 0;
    this.dataOperacao = dataOperacao ?? DateTime.now();
    nomeMoeda = moeda.nome;
    siglaMoeda = moeda.sigla;
  }
}
