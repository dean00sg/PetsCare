import 'dart:convert';
import 'package:frontend/admin/models/petprofile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PetProfileRepository {
  final String apiUrl = 'http://127.0.0.1:8000/pets/all-pets-admin';

  Future<List<PetProfileModel>> fetchPets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((pet) => PetProfileModel.fromJson(pet)).toList();
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }

  Future<void> createPet(PetProfileModel petData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('$apiUrl/create-pet'), // Assuming there is an endpoint for creating pets
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(petData.toJson()),
      );

      if (response.statusCode == 200) {
        print('Pet created successfully');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to create pet');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }
}