import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/users/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final String apiUrl = 'http://127.0.0.1:8000/authentication/login';

  Future<String> login(LoginModel loginData) async {
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
        await prefs.setString('token', data['access_token']);  // เก็บ token
        return data['access_token'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to login');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }
}
