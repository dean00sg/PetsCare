import 'dart:convert';
import 'package:frontend/users/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final String apiUrl;

  ProfileRepository({required this.apiUrl});

  Future<UserProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/authentication/profile'),  
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);  
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized, please log in again');
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
