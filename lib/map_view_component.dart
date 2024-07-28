import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'api_service.dart';

class MapViewComponent extends StatefulWidget {
  @override
  _MapViewComponentState createState() => _MapViewComponentState();
}

class _MapViewComponentState extends State<MapViewComponent> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchVehiclePositions();
  }

  _fetchVehiclePositions() async {
    try {
      final positions = await ApiService.fetchVehiclePositions();
      setState(() {
        _markers.clear();
        for (var vehicle in positions) {
          if (vehicle['px'] != null && vehicle['py'] != null) {
            _markers.add(
              Marker(
                markerId: MarkerId(vehicle['p'].toString()),
                position: LatLng(vehicle['py'], vehicle['px']),
                infoWindow: InfoWindow(
                  title: 'Veículo ${vehicle['p']}',
                  snippet: 'Linha ${vehicle['a']}',
                ),
              ),
            );
          } else {
            print('Dados inválidos para o veículo ${vehicle['p']}');
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
        title: Text(
          'Posições dos Veículos',
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
        centerTitle: true, // Centraliza o título
        backgroundColor: Color(0xFF003380), // Define a cor da AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Define a cor da seta como branca
        ),
      ),
      body: _errorMessage.isEmpty
          ? GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
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
