import 'package:flutter/material.dart';
import 'map_view_component.dart';
import 'bus_lines_screen.dart';
import 'stops_map_screen.dart';

void main() {
  runApp(SPTransApp());
}

class SPTransApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remova a marca de debug
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teste Android(Aiko)',
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
        centerTitle: true, // Centraliza o título
        backgroundColor: Color(0xFF003380), // Define a cor da AppBar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(), // Adiciona espaço flexível entre AppBar e botões
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200, // Define a largura dos botões
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapViewComponent()),
                    );
                  },
                  child: Text('Mapa'),
                ),
              ),
              SizedBox(
                width: 200, // Define a largura dos botões
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusLinesScreen()),
                    );
                  },
                  child: Text('Linhas de Ônibus'),
                ),
              ),
              SizedBox(
                width: 200, // Define a largura dos botões
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StopsMapScreen()),
                    );
                  },
                  child: Text('Paradas de Ônibus'),
                ),
              ),
            ],
          ),
          Spacer(), // Adiciona espaço flexível entre botões e footer
          Container(
            color: Color(0xFF003380), // Define a cor de fundo do rodapé
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Desenvolvido por: Emerson Souza',
                style: TextStyle(fontSize: 20, color: Colors.white), // Define a cor do texto como branca para contraste
              ),
            ),
          ),
        ],
      ),
    );
  }
}
