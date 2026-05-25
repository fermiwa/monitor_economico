import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/indicador_model.dart';
import 'analise_grafico_screen.dart';

class ConsultaPeriodoScreen extends StatefulWidget {
  final Indicador indicador;

  const ConsultaPeriodoScreen({Key? key, required this.indicador}) : super(key: key);

  @override
  State<ConsultaPeriodoScreen> createState() => _ConsultaPeriodoScreenState();
}

class _ConsultaPeriodoScreenState extends State<ConsultaPeriodoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime? _dataInicial;
  DateTime? _dataFinal;

  final TextEditingController _dataInicialController = TextEditingController();
  final TextEditingController _dataFinalController = TextEditingController();

  // função que abre o calendário do próprio flutter
  Future<void> _selecionarData(BuildContext context, bool isDataInicial) async {
    final DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime.now(),  
    );

    if (selecionada != null) {
      setState(() {
        if (isDataInicial) {
          _dataInicial = selecionada;
          // formatação da data
          _dataInicialController.text = DateFormat('dd/MM/yyyy').format(selecionada);
        } else {
          _dataFinal = selecionada;
          _dataFinalController.text = DateFormat('dd/MM/yyyy').format(selecionada);
        }
      });
    }
  }

  void _submeterFormulario() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnaliseGraficoScreen(
            indicador: widget.indicador,
            dataInicialStr: _dataInicialController.text,
            dataFinalStr: _dataFinalController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar ${widget.indicador.nome}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Selecione o intervalo de tempo para análise:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _dataInicialController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Data Inicial',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                ),
                onTap: () => _selecionarData(context, true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a data inicial.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dataFinalController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Data Final',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range),
                ),
                onTap: () => _selecionarData(context, false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a data final.';
                  }
                  if (_dataInicial != null && _dataFinal != null) {
                    if (_dataFinal!.isBefore(_dataInicial!)) {
                      return 'A data final não pode ser menor que a inicial';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submeterFormulario,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Consultar Histórico',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}