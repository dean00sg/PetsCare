// lib/users/repositories/signup_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/users/models/signup_model.dart';

class SignupRepository {
  final String apiUrl = 'http://10.0.2.2:8000/authentication/register';

  Future<SignupModel> signup(SignupModel signupData) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(signupData.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data.isNotEmpty) {
        return SignupModel.fromJson(data);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }
}
