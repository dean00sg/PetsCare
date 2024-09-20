import 'dart:convert';

import 'package:frontend/admin/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String apiUrl = 'http://10.0.2.2:8000/admin_manage/';

  Future<List<UserProfilePets>> getProfile() async {
 
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // ส่ง request พร้อมกับ token ใน headers
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserProfilePets.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user profiles');
    }
  }
}
