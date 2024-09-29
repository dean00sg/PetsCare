import 'dart:convert';
import 'package:frontend/admin/models/vaccination.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PetVacRepository {
  final String apiUrl;

  PetVacRepository({required this.apiUrl});

  Future<List<PetVacProfile>> fetchPetVacProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$apiUrl/pets_vac/get_all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PetVacProfile.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load vaccination profiles');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }

  Future<void> createPetVacProfile(AddPetVacProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('$apiUrl/pets_vac/pet_vac_profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create pet vaccination profile');
    }
  }

  fetchPetById(String petsId) {}
}
