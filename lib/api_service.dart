
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'http://192.168.31.5:8080/api';

  Future<List<String>> getFigureTypes() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/figure-types'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return List<String>.from(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to load figure types');
    }
  }

  Future<Map<String, dynamic>> calculateCircle(double radius) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/figures/circle'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'radius': radius}),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to calculate circle parameters');
    }
  }

  Future<Map<String, dynamic>> calculateRectangle(double sideA, double sideB) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/figures/rectangle'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({'sideA': sideA, 'sideB': sideB}),
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to calculate rectangle parameters');
    }
  }
}

