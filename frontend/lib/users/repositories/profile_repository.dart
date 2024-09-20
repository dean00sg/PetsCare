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
      Uri.parse('$apiUrl/profile/'),
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/authentication/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      bool removed = await prefs.remove('token');
      if (!removed) {
        throw Exception('Failed to remove token');
      }
      print('User logged out successfully');
    } else {
      throw Exception('Failed to log out');
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'first_name': updatedProfile.firstName,
        'last_name': updatedProfile.lastName,
        'contact_number': updatedProfile.phone,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

}
