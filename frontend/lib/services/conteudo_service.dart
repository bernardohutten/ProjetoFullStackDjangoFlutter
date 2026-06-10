import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ConteudoService {
  static const String baseUrl = AuthService.baseUrl;

  static Future<List<dynamic>> listarConteudos() async {
    final token = await AuthService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/api/conteudos/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
}