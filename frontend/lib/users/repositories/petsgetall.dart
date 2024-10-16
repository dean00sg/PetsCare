import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/users/models/petslidebar_models.dart';
import 'package:frontend/users/models/create_pet_model.dart';

class CreatePetRepository {
  final String apiUrl = 'https://pets-care.onrender.com/pets/'; 


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
          'type_pets': petData.typePets,  
          'sex': petData.sex,
          'breed': petData.breed,
          'birth_date': petData.dateOfBirth,  
          'weight': petData.weight, 
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

  Future<List<Pet>> fetchPets() async {
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

        return data.map((pet) {
          return Pet(
            petsId: pet['pets_id'], 
            name: pet['name'],
            imagePath: PetTypeImage.getImagePath(pet['type_pets']), 
          );
        }).toList();
      } else {
        throw Exception('Failed to load pets');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }
}
