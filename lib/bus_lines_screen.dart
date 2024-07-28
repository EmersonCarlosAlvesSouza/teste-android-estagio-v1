// lib/bus_lines_screen.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

class BusLinesScreen extends StatefulWidget {
  @override
  _BusLinesScreenState createState() => _BusLinesScreenState();
}

class _BusLinesScreenState extends State<BusLinesScreen> {
  List<dynamic> _busLines = [];
  String _errorMessage = '';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBusLines('');
  }

  _fetchBusLines(String searchTerm) async {
    try {
      final busLines = await ApiService.fetchBusLines(searchTerm);
      setState(() {
        _busLines = busLines;
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
        title: Text('Linhas de Ônibus',
        style: TextStyle(fontSize: 23, color: Colors.white),),
        centerTitle: true, // Centraliza o título
        backgroundColor: Color(0xFF003380),iconTheme: IconThemeData(
        color: Colors.white, // Define a cor da seta como branca
      ), // Define a cor da AppBar
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Linha',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _fetchBusLines(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: _errorMessage.isEmpty
                ? ListView.builder(
              itemCount: _busLines.length,
              itemBuilder: (context, index) {
                final busLine = _busLines[index];
                return ListTile(
                  title: Text('Linha ${busLine['lt']} - ${busLine['tp']} - ${busLine['ts']}'),
                  subtitle: Text('Código: ${busLine['cl']}'),
                );
              },
            )
                : Center(child: Text(_errorMessage)),
          ),
        ],
      ),
    );
  }
}
