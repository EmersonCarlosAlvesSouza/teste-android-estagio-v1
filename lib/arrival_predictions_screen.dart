// lib/arrival_predictions_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

class ArrivalPredictionsScreen extends StatefulWidget {
  final int stopCode;

  ArrivalPredictionsScreen({required this.stopCode});

  @override
  _ArrivalPredictionsScreenState createState() => _ArrivalPredictionsScreenState();
}

class _ArrivalPredictionsScreenState extends State<ArrivalPredictionsScreen> {
  List<dynamic> _predictions = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPredictions();
  }

  _fetchPredictions() async {
    try {
      final predictions = await ApiService.fetchArrivalPredictions(widget.stopCode);
      setState(() {
        _predictions = predictions;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previsões de Chegada', style: TextStyle(fontSize: 23, color: Colors.white),),
        centerTitle: true, // Centraliza o título
        backgroundColor: Color(0xFF003380),iconTheme: IconThemeData(
        color: Colors.white, // Define a cor da seta como branca
      ),),
      body: _errorMessage.isEmpty
          ? ListView.builder(
        itemCount: _predictions.length,
        itemBuilder: (context, index) {
          final line = _predictions[index];
          return ListTile(
            title: Text('Linha: ${line['c']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var vehicle in line['vs'])
                  Text('Veículo ${vehicle['p']} - Chegada em: ${vehicle['t']}'),
              ],
            ),
          );
        },
      )
          : Center(child: Text(_errorMessage)),
    );
  }
}
