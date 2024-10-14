import 'dart:convert';
import 'package:frontend/users/models/petprofile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PetProfileRepository {
  final String apiUrl = 'https://pets-care.onrender.com/pets/byid';

  Future<PetProfile> fetchPetByName(String petsId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$apiUrl?pet_id=$petsId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PetProfile.fromJson(data);
      } else {
        throw Exception('Failed to load pet profile');
      }
    } catch (e) {
      throw Exception('Error fetching pet profile: $e');
    }
  }

  Future<void> updatePetProfile(String petsId, PetProfile petProfile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.put(
        Uri.parse('https://pets-care.onrender.com/pets/$petsId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': petProfile.name,
          'birth_date': petProfile.birthDate,
          'weight': petProfile.weight,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update pet profile');
      }
    } catch (e) {
      throw Exception('Error updating pet profile: $e');
    }
  }
}
