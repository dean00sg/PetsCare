import 'dart:convert';
import 'package:frontend/admin/models/chechhealth_rec.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HealthRecordRepository {
  final String apiUrl = 'https://pets-care.onrender.com';

  Future<List<HealthRecord>> fetchHealthRecords() async {
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
      return data.map((json) => HealthRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load health records');
    }
  }

  Future<void> addHealthRecord(HealthRecord healthRecord) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      //POST request
      final response = await http.post(
        Uri.parse('$apiUrl/notehealth/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(healthRecord.toJson()), 
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Health record created successfully");
      } else {
        throw Exception('Failed to create health record: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }

}
