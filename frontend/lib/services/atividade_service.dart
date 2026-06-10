import 'dart:convert';

import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AtividadeService {
  static const String baseUrl = AuthService.baseUrl;

  static Future<List<dynamic>> listarAtividades() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/atividades/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  static Future<bool> criarAtividade(String nome) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/atividades/criar/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nome_atividade': nome,
      }),
    );

    return response.statusCode == 201;
  }

  static Future<bool> registrarAtividade(int id) async {
    final token = await AuthService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/atividades/$id/registrar/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 201;
  }

  static Future<bool> deletarAtividade(int id) async {
    final token = await AuthService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/api/atividades/$id/deletar/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}