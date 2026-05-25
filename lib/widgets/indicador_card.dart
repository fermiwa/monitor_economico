import 'package:flutter/material.dart';
import '../models/indicador_model.dart';
import '../models/dados_serie_model.dart';
import '../services/bcb_api_service.dart';
import '../screens/consulta_periodo_screen.dart';

class IndicadorCard extends StatelessWidget {
  final Indicador indicador;
  final BcbApiService _apiService = BcbApiService();

  IndicadorCard({Key? key, required this.indicador}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          indicador.nome,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Código SGS: ${indicador.codigo}'),
        trailing: FutureBuilder<DadosSerie>(
          future: _apiService.fetchUltimoValor(indicador.codigo),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            } else if (snapshot.hasError) {
              return const Icon(Icons.error_outline, color: Colors.red);
            } else if (snapshot.hasData) {
              final dado = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${dado.valor.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dado.data,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              );
            }
            return const Text('--');
          },
        ),
        // clica no card -> vai pra tela 2
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConsultaPeriodoScreen(indicador: indicador),
            ),
          );
        },
      ),
    );
  }
}