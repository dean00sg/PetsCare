import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/users/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jwt_decoder/jwt_decoder.dart';

class LoginRepository {
  final String apiUrl = 'http://10.0.2.2:8000/authentication/login';

  Future<Map<String, String>> login(LoginModel loginData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': loginData.username,
          'password': loginData.password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();

        final token = data['access_token'] ?? '';
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final role = decodedToken['role'] ?? ''; // Extract role from token

        await prefs.setString('token', token);
        await prefs.setString('role', role);
        print('Decoded role: $role'); // Print decoded role
        return {'access_token': token, 'role': role};
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to login');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }
}
