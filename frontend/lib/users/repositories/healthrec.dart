import 'dart:convert';

import 'package:frontend/users/models/healthrec.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HealthRecordUserRepository {
  final String apiUrl = 'http://10.0.2.2:8000';

  Future<List<HealthRecordUser>> fetchHealthRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/notehealth/all/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => HealthRecordUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load health records');
    }
  }
}
