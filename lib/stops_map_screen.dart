// lib/stops_map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'arrival_predictions_screen.dart';
import 'api_service.dart';

class StopsMapScreen extends StatefulWidget {
  @override
  _StopsMapScreenState createState() => _StopsMapScreenState();
}

class _StopsMapScreenState extends State<StopsMapScreen> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStops('');
  }

  _fetchStops(String searchTerm) async {
    try {
      final stops = await ApiService.fetchStops(searchTerm);
      setState(() {
        _markers.clear();
        for (var stop in stops) {
          if (stop['py'] != null && stop['px'] != null) {
            _markers.add(
              Marker(
                markerId: MarkerId(stop['cp'].toString()),
                position: LatLng(stop['py'], stop['px']),
                infoWindow: InfoWindow(
                  title: 'Parada ${stop['np']}',
                  snippet: 'Código: ${stop['cp']}',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArrivalPredictionsScreen(stopCode: stop['cp']),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            print('Dados inválidos para a parada ${stop['cp']}');
          }
        }
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
        title: Text('Paradas de Ônibus', style: TextStyle(fontSize: 23, color: Colors.white),),
      centerTitle: true, // Centraliza o título
      backgroundColor: Color(0xFF003380),iconTheme: IconThemeData(
      color: Colors.white, // Define a cor da seta como branca
    ),),

      body: _errorMessage.isEmpty
          ? GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
          _fetchStops('');
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(-23.55052, -46.633308),
          zoom: 12,
        ),
        markers: _markers,
      )
          : Center(child: Text(_errorMessage)),
    );
  }
}
