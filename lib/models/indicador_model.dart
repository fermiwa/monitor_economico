class Indicador {
  final String id;
  final String nome;
  final int codigo;

  Indicador({
    required this.id,
    required this.nome,
    required this.codigo,
  });

  factory Indicador.fromFirestore(Map<String, dynamic> data, String id) {
    return Indicador(
      id: id,
      nome: data['nome'] ?? 'Sem nome',
      codigo: int.parse(data['codigo'].toString()),
    );
  }
}