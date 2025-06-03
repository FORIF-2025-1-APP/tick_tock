import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// TODO API
class TodoApi {
  static const String baseUrl = 'https://foriftiktokapi.seongjinemong.app';
  final http.Client _client;
  final String? accessToken;
  final _storage = const FlutterSecureStorage();

  TodoApi({http.Client? client, this.accessToken})  : _client = client ?? http.Client();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'auth_token');

    return {

    'Content-Type' : 'application/json',
    'Authorization': 'Bearer $token',
    };
  }

  // POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await _client.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201){
      return json.decode(response.body) as Map<String, dynamic>; // JSON 객체
    } else{
      print('=== Error Response Body: ${response.body}');
      throw Exception('POST $endpoint failed: ${response.statusCode}');
    }
  }


  //GET
  Future<Map<String, dynamic>> get (String endpoint) async {
    final response = await _client.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('GET $endpoint failed: ${response.statusCode}');
    }
  }

  //PATCH
  Future<Map<String, dynamic>> patch (String endpoint, Map<String, dynamic> data) async {

    final response = await _client.patch(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: json.encode(data),
    );
    if(response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('PATCH $endpoint failed: ${response.statusCode}');
    }
  }

  //DELETE
  Future<Map<String, dynamic>> delete(String endpoint, Map<String, dynamic> data) async {
    final response = await _client.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: json.encode(data),
    );
    print('🟡 DELETE response.body: ${response.body}');
    
    if (response.statusCode == 204 || response.statusCode == 200) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('DELETE $endpoint failed: ${response.statusCode}\nBody: ${response.body}');
    }
  }
}