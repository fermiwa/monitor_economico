import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class AnalisesSalvasScreen extends StatefulWidget {
  const AnalisesSalvasScreen({Key? key}) : super(key: key);

  @override
  State<AnalisesSalvasScreen> createState() => _AnalisesSalvasScreenState();
}

class _AnalisesSalvasScreenState extends State<AnalisesSalvasScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  // janela de confirmação para deletar
  void _confirmarExclusao(BuildContext context, String idDoc, String nomeAnalise) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Excluir Análise'),
            ],
          ),
          content: Text('Tem certeza que deseja apagar a análise "$nomeAnalise"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); 
                try {
                  await _firestoreService.deletarAnalise(idDoc);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Análise deletada com sucesso.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao deletar: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análises Salvas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.streamAnalises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao ler registros: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Nenhuma análise salva.\nFaça uma consulta e salve os resultados!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            );
          }

          final listaDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: listaDocs.length,
            itemBuilder: (context, index) {
              final doc = listaDocs[index];
              final map = doc.data() as Map<String, dynamic>;

              final String idDoc = doc.id;
              final String nomeAnalise = map['nome_analise'] ?? 'Sem título';
              final String indicador = map['indicador_nome'] ?? 'Desconhecido';
              final String inicio = map['data_inicio'] ?? '';
              final String fim = map['data_fim'] ?? '';
              final double media = (map['media_calculada'] ?? 0.0).toDouble();
              final double variacao = (map['variacao_calculada'] ?? 0.0).toDouble();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.analytics_outlined, color: Colors.white),
                  ),
                  title: Text(
                    nomeAnalise,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Indicador: $indicador', style: const TextStyle(color: Colors.black87)),
                        Text('Período: $inicio a $fim', style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Chip(
                              label: Text('Média: ${media.toStringAsFixed(2)}%'),
                              backgroundColor: Colors.orange.shade50,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text('Var: ${variacao.toStringAsFixed(2)}%'),
                              backgroundColor: Colors.purple.shade50,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                    onPressed: () => _confirmarExclusao(context, idDoc, nomeAnalise),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}