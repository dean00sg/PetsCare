import 'dart:convert';
import 'package:frontend/users/models/vaccination_pet.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PetVacUserRepository { 
  final String apiUrl = 'http://10.0.2.2:8000/pets_vac/pet_vac_profile/';

  Future<PetVacUserProfile> fetchPetById(String petsId) async { 
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$apiUrl$petsId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PetVacUserProfile.fromJson(data);
      } else {
        throw Exception('Failed to load pet vaccine profile');
      }
    } catch (e) {
      throw Exception('Error fetching pet vaccine profile: $e');
    }
  }
}
