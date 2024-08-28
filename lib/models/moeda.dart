import 'package:cryptoquote/repositories/moeda_repository.dart';

class Moeda {
  String icone;
  String nome;
  String sigla;
  double preco;

  Moeda({
    required this.icone,
    required this.nome,
    required this.sigla,
    required this.preco,
  });

  factory Moeda.fromSigla(String sigla) {
    return MoedaRepository.tabela.firstWhere(
      (element) => element.sigla == sigla,
    );
  }
}
