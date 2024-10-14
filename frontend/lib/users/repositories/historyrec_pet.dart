import 'dart:convert';
import 'package:frontend/users/models/historyrec_pet.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRecUserRepository {
  final String apiUrl = 'https://pets-care.onrender.com';

  Future<List<HistoryRecUserModel>> fetchPetById(String petsId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$apiUrl/History Records/history_rec/{pets_id}?pet_id=$petsId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => HistoryRecUserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load history records');
      }
    } catch (e) {
      throw Exception('Error fetching history records: $e');
    }
  }
}
