import 'dart:convert';
import 'package:frontend/admin/models/check_historyrec.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  final String apiUrl;

  HistoryRepository({required this.apiUrl});

  // Fetch all history records
  Future<List<HistoryRecord>> fetchHistoryRecords() async {
    try {
      // Retrieve the token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      // Send a GET request to fetch the history records
      final response = await http.get(
        Uri.parse('$apiUrl/History Records/history_rec/get_all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // If the request was successful, parse the data
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
}
