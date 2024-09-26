import 'dart:convert';
import 'package:frontend/admin/models/historyrec.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  final String apiUrl;

  HistoryRepository({required this.apiUrl});

  Future<List<HistoryRecord>> fetchHistoryRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$apiUrl/History Records/history_rec/get_all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => HistoryRecord.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load history records');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }

  Future<AddHistoryRec> createHistoryRecord(AddHistoryRec newRecord) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('$apiUrl/History Records/history_rec/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(newRecord.toJson()),
      );

      if (response.statusCode == 201) {
        return AddHistoryRec.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create history record: ${response.body}');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }
}
