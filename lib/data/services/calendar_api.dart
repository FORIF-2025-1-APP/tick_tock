import 'package:http/http.dart' as http;
import 'dart:convert';

/// Calendar API 클라이언트
class CalendarApi {
  static const String baseUrl = 'https://foriftiktokapi.seongjinemong.app';
  final http.Client _client;
  final String? accessToken;

  CalendarApi({http.Client? client, this.accessToken}) : _client = client ?? http.Client();

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to put data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> data) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to patch data: ${response.statusCode}');
    }
  }
} 