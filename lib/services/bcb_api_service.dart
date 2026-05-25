import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dados_serie_model.dart';

class BcbApiService {
  Future<DadosSerie> fetchUltimoValor(int codigo) async {
    final url = Uri.parse(
      'https://api.bcb.gov.br/dados/serie/bcdata.sgs.$codigo/dados/ultimos/1?formato=json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> dados = jsonDecode(response.body);
        if (dados.isNotEmpty) {
          return DadosSerie.fromJson(dados.first);
        }
        throw Exception('Nenhum dado encontrado');
      } else {
        throw Exception('Erro ao acessar a API');
      }
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }

  // busca a partir dos filtros de data
  Future<List<DadosSerie>> fetchPeriodo(
    int codigo,
    String dataInicial,
    String dataFinal,
  ) async {
    final url = Uri.parse(
      'https://api.bcb.gov.br/dados/serie/bcdata.sgs.$codigo/dados?formato=json&dataInicial=$dataInicial&dataFinal=$dataFinal',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> dados = jsonDecode(response.body);
        return dados.map((item) => DadosSerie.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao buscar na API');
      }
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }
}