class DadosSerie {
  final String data;
  final double valor;

  DadosSerie({
    required this.data,
    required this.valor,
  });

  factory DadosSerie.fromJson(Map<String, dynamic> json) {
    final valorTratado = json['valor'].toString().replaceAll(',', '.');
    
    return DadosSerie(
      data: json['data'] ?? '',
      valor: double.tryParse(valorTratado) ?? 0.0,
    );
  }
}