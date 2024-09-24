import 'dart:convert';
import 'package:frontend/admin/models/chechhealth_rec.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HealthRecordRepository {
  final String apiUrl = 'http://10.0.2.2:8000';

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

  Future<HealthRecord> addHealthRecord(HealthRecord healthRecord) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/notehealth/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(healthRecord.toJson()),
    );

    if (response.statusCode == 201) {
      return HealthRecord.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create health record. Server response: ${response.body}');
    }
  }

}
