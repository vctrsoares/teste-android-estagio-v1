import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey;
  String? _authToken;

  ApiService(this.apiKey);

  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse(
          'http://api.olhovivo.sptrans.com.br/v2.1/Login/Autenticar?token=$apiKey'),
    );

    if (response.statusCode == 200 && response.body == 'true') {
      _authToken = response.headers['set-cookie'];
      print('Autenticado com sucesso');
    } else {
      print('Falha na autenticação: ${response.body}');
      throw Exception('Falha na autenticação');
    }
  }

  Future<List<dynamic>> fetchVehiclePositions() async {
    if (_authToken == null) {
      throw Exception('Token de autenticação não disponível');
    }

    final response = await http.get(
      Uri.parse('http://api.olhovivo.sptrans.com.br/v2.1/Posicao'),
      headers: {'cookie': _authToken!},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['l'];
    } else {
      print('Falha ao carregar posições dos veículos: ${response.body}');
      throw Exception('Falha ao carregar posições dos veículos');
    }
  }

  Future<List<dynamic>> fetchBusLines(String searchTerm) async {
    if (_authToken == null) {
      throw Exception('Token de autenticação não disponível');
    }

    final response = await http.get(
      Uri.parse(
          'http://api.olhovivo.sptrans.com.br/v2.1/Linha/Buscar?termosBusca=$searchTerm'),
      headers: {'cookie': _authToken!},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print('Falha ao carregar linhas de ônibus: ${response.body}');
      throw Exception('Falha ao carregar linhas de ônibus');
    }
  }

  Future<List<dynamic>> fetchBusStops(String searchTerm) async {
    if (_authToken == null) {
      throw Exception('Token de autenticação não disponível');
    }

    final response = await http.get(
      Uri.parse(
          'http://api.olhovivo.sptrans.com.br/v2.1/Parada/Buscar?termosBusca=$searchTerm'),
      headers: {'cookie': _authToken!},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      print('Falha ao carregar pontos de parada: ${response.body}');
      throw Exception('Falha ao carregar pontos de parada');
    }
  }

  Future<List<dynamic>> fetchArrivalPredictions(int stopId) async {
    if (_authToken == null) {
      throw Exception('Token de autenticação não disponível');
    }

    final response = await http.get(
      Uri.parse(
          'http://api.olhovivo.sptrans.com.br/v2.1/Previsao/Parada?codigoParada=$stopId'),
      headers: {'cookie': _authToken!},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['ps'];
    } else {
      print('Falha ao carregar previsões de chegada: ${response.body}');
      throw Exception('Falha ao carregar previsões de chegada');
    }
  }
}