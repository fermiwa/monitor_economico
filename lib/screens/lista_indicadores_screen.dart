import 'package:flutter/material.dart';
import '../models/indicador_model.dart';
import '../services/firestore_service.dart';
import '../widgets/indicador_card.dart';
import 'analises_salvas_screen.dart'; 

class ListaIndicadoresScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  ListaIndicadoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Econômico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Análises Salvas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AnalisesSalvasScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Indicador>>(
        stream: _firestoreService.streamIndicadores(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar indicadores: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhum indicador cadastrado no Firestore.'),
            );
          }

          final indicadores = snapshot.data!;

          return ListView.builder(
            itemCount: indicadores.length,
            itemBuilder: (context, index) {
              return IndicadorCard(indicador: indicadores[index]);
            },
          );
        },
      ),
    );
  }
}