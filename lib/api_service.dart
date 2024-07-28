// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'https://api.olhovivo.sptrans.com.br/v2.1';
  static const String _apiKey = 'cc88316779b5ef435b14c6df4116945df6468adedd448d3dc3ccf32e087d075d';  // Substitua pela sua chave de API
  static bool isAuthenticated = false;
  static var client = http.Client();
  static Map<String, String> headers = {};

  static Future<void> authenticate() async {
    final response = await client.post(
      Uri.parse('$_baseUrl/Login/Autenticar?token=$_apiKey'),
    );

    if (response.statusCode == 200 && response.body == 'true') {
      isAuthenticated = true;
      headers = {'Cookie': response.headers['set-cookie'] ?? ''};
      print('Autenticado com sucesso');
    } else {
      throw Exception('Falha na autenticação');
    }
  }

  static Future<void> ensureAuthenticated() async {
    if (!isAuthenticated) {
      await authenticate();
    }
  }

  static Future<List<dynamic>> fetchVehiclePositions() async {
    await ensureAuthenticated();
    final response = await client.get(Uri.parse('$_baseUrl/Posicao'), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Dados recebidos: ${data}');
      if (data != null && data['vs'] != null) {
        return data['vs'];
      } else {
        return [];
      }
    } else {
      print('Erro na resposta: ${response.body}');
      throw Exception('Falha ao carregar posições dos veículos: ${response.body}');
    }
  }

  static Future<List<dynamic>> fetchBusLines(String searchTerm) async {
    await ensureAuthenticated();
    final response = await client.get(Uri.parse('$_baseUrl/Linha/Buscar?termosBusca=$searchTerm'), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Linhas recebidas: ${data}');
      if (data != null) {
        return data;
      } else {
        return [];
      }
    } else {
      print('Erro na resposta: ${response.body}');
      throw Exception('Falha ao carregar informações das linhas: ${response.body}');
    }
  }

  static Future<List<dynamic>> fetchStops(String searchTerm) async {
    await ensureAuthenticated();
    final response = await client.get(Uri.parse('$_baseUrl/Parada/Buscar?termosBusca=$searchTerm'), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Paradas recebidas: ${data}');
      if (data != null) {
        return data;
      } else {
        return [];
      }
    } else {
      print('Erro na resposta: ${response.body}');
      throw Exception('Falha ao carregar paradas: ${response.body}');
    }
  }

  static Future<List<dynamic>> fetchArrivalPredictions(int stopCode) async {
    await ensureAuthenticated();
    final response = await client.get(Uri.parse('$_baseUrl/Previsao/Parada?codigoParada=$stopCode'), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Previsões recebidas: ${data}');
      if (data != null && data['p'] != null) {
        return data['p']['l'];
      } else {
        return [];
      }
    } else {
      print('Erro na resposta: ${response.body}');
      throw Exception('Falha ao carregar previsões: ${response.body}');
    }
  }
}
