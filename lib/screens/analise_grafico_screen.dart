import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/indicador_model.dart';
import '../models/dados_serie_model.dart';
import '../services/bcb_api_service.dart';
import '../services/firestore_service.dart';
import '../widgets/estatistica_card.dart';

class AnaliseGraficoScreen extends StatefulWidget {
  final Indicador indicador;
  final String dataInicialStr;
  final String dataFinalStr;

  const AnaliseGraficoScreen({
    Key? key,
    required this.indicador,
    required this.dataInicialStr,
    required this.dataFinalStr,
  }) : super(key: key);

  @override
  State<AnaliseGraficoScreen> createState() => _AnaliseGraficoScreenState();
}

// calculo das 4 estatísticas
class _AnaliseGraficoScreenState extends State<AnaliseGraficoScreen> {
  final BcbApiService _apiService = BcbApiService();
  final FirestoreService _firestoreService = FirestoreService();
  final _nomeAnaliseController = TextEditingController();

  double _minimo = 0.0;
  double _maximo = 0.0;
  double _media = 0.0;
  double _variacao = 0.0;

  void _calcularEstatistias(List<DadosSerie> lista) {
    if (lista.isEmpty) return;

    final valores = lista.map((e) => e.valor).toList();
    
    _minimo = valores.reduce(math.min);
    _maximo = valores.reduce(math.max);
    _media = valores.reduce((a, b) => a + b) / valores.length;
    
    double valorInicial = lista.first.valor;
    double valorFinal = lista.last.valor;
    _variacao = valorInicial != 0 ? ((valorFinal - valorInicial) / valorInicial) * 100 : 0.0;
  }

  void _mostrarDialogosalvar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Salvar Análise'),
          content: TextField(
            controller: _nomeAnaliseController,
            decoration: const InputDecoration(
              labelText: 'Nome da Análise',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nomeAnaliseController.text.trim().length >= 3) {
                  final dados = {
                    'nome_analise': _nomeAnaliseController.text.trim(),
                    'indicador_nome': widget.indicador.nome,
                    'data_inicio': widget.dataInicialStr,
                    'data_fim': widget.dataFinalStr,
                    'media_calculada': double.parse(_media.toStringAsFixed(2)),
                    'variacao_calculada': double.parse(_variacao.toStringAsFixed(2)),
                    'criado_em': DateTime.now().toIso8601String(),
                  };

                  await _firestoreService.salvarAnalise(dados);
                  _nomeAnaliseController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Análise salva com sucesso!')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados e Gráficos')),
      body: FutureBuilder<List<DadosSerie>>(
        future: _apiService.fetchPeriodo(
          widget.indicador.codigo,
          widget.dataInicialStr,
          widget.dataFinalStr,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao buscar dados: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum dado no período selecionado.'));
          }

          final dadosBCB = snapshot.data!;
          _calcularEstatistias(dadosBCB);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Série histórica do indicador: ${widget.indicador.nome}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('Período: ${widget.dataInicialStr} até ${widget.dataFinalStr}', textAlign: TextAlign.center),
                const SizedBox(height: 24),

                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.trending_up, size: 48, color: Colors.blue),
                        SizedBox(height: 8),
                        Text(
                          'Série Histórica Processada com Sucesso',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Grade com as 4 estatísticas calculadas
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    EstatisticaCard(titulo: 'Mínimo', valor: '${_minimo.toStringAsFixed(2)}%', icon: Icons.trending_down, corIcone: Colors.red),
                    EstatisticaCard(titulo: 'Máximo', valor: '${_maximo.toStringAsFixed(2)}%', icon: Icons.trending_up, corIcone: Colors.green),
                    EstatisticaCard(titulo: 'Média do Período', valor: '${_media.toStringAsFixed(2)}%', icon: Icons.functions, corIcone: Colors.orange),
                    EstatisticaCard(titulo: 'Variação %', valor: '${_variacao.toStringAsFixed(2)}%', icon: Icons.compare_arrows, corIcone: Colors.purple),
                  ],
                ),
                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: () => _mostrarDialogosalvar(context),
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Análise no Banco'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}