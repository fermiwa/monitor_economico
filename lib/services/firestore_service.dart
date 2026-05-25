import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/indicador_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tela 1 — Lista de Indicadores
  Stream<List<Indicador>> streamIndicadores() {
    return _firestore.collection('indicadores').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Indicador.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Tela 3 — Análise e Visualização
  Future<void> salvarAnalise(Map<String, dynamic> dadosAnalise) async {
    try {
      await _firestore.collection('analises_salvas').add(dadosAnalise);
    } catch (e) {
      throw Exception('Erro ao salvar análise: $e');
    }
  }

  // Tela 4 — Análises Salvas
  Stream<QuerySnapshot> streamAnalises() {
    return _firestore
        .collection('analises_salvas')
        .orderBy('criado_em', descending: true)
        .snapshots();
  }

  // Tela 4 — Análises Salvas
  Future<void> deletarAnalise(String idDocumento) async {
    try {
      await _firestore.collection('analises_salvas').doc(idDocumento).delete();
    } catch (e) {
      throw Exception('Erro ao deletar análise: $e');
    }
  }
}