import 'dart:convert';
import 'package:frontend/admin/models/petprofileuser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PetProfileUserRepository {
  final String apiUrl = 'https://pets-care.onrender.com/pets/all-pets-admin';

  Future<List<PetProfileUserModel>> fetchPets() async {
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
        return data.map((pet) => PetProfileUserModel.fromJson(pet)).toList();
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }

  Future<void> createPet(PetProfileUserModel petData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse('$apiUrl/create-pet'), 
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