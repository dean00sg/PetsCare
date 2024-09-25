import 'dart:convert';
import 'package:frontend/users/models/petprofile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PetProfileRepository {
  final String apiUrl = 'http://10.0.2.2:8000/pets/byname'; 
  final String updateApiUrl = 'http://10.0.2.2:8000/pets/update';


  Future<PetProfile> fetchPetByName(String petName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$apiUrl?pet_name=$petName'),
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

  Future<void> updatePetProfile(PetProfile petProfile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.put(
        Uri.parse(updateApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(petProfile.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update pet profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating pet profile: $e');
    }
  }
}
