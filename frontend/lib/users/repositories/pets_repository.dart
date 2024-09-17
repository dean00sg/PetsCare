import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/users/models/create_pet_model.dart';

class CreatePetRepository {
  final String apiUrl = 'http://127.0.0.1:8000/pets'; // Update with your actual API URL

  Future<void> createPet(PetModel petData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': petData.name,
          'type_pets': petData.typePets,  // Ensure the field matches 'type_pets'
          'sex': petData.sex,
          'breed': petData.breed,
          'birth_date': petData.dateOfBirth,  // Ensure 'birth_date' is passed correctly
          'weight': petData.weight,  // Send weight as a double
        }),
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
