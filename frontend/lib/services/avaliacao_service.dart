import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AvaliacaoService {
  static const String baseUrl = AuthService.baseUrl;

  static Future<List<dynamic>> listarAvaliacoes() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/avaliacoes/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  static Future<Map<String, dynamic>?> detalheAvaliacao(int id) async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/avaliacoes/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<bool> responderAvaliacao({
    required int avaliacaoId,
    required List<Map<String, dynamic>> respostas,
  }) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/avaliacoes/$avaliacaoId/responder/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'respostas': respostas,
      }),
    );

    return response.statusCode == 200;
  }
}