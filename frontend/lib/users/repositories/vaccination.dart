import 'dart:convert';
import 'package:frontend/users/models/vaccination_pet.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserPetVacRepository {
  final String apiUrl;

  UserPetVacRepository({required this.apiUrl});

  /// สร้างข้อมูลวัคซีนสำหรับสัตว์เลี้ยง
  Future<void> createPetVacProfile(AddPetVacProfile profile) async {
    try {
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

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create pet vaccination profile');
      }
    } catch (e) {
      throw Exception('Error creating pet vaccination profile: $e');
    }
  }

  /// ดึงข้อมูลวัคซีนทั้งหมดของสัตว์เลี้ยงโดยใช้รหัสสัตว์เลี้ยง
  Future<List<PetVacUserProfile>> fetchVaccinationsByPetId(int petsId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('$apiUrl/pets_vac/$petsId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PetVacUserProfile.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load pet vaccination profiles');
      }
    } catch (e) {
      throw Exception('Error fetching pet vaccination profiles: $e');
    }
  }

  /// อัปเดตข้อมูลวัคซีนของสัตว์เลี้ยง
  Future<void> updateVaccinationProfile(int vacId, AddPetVacProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.put(
        Uri.parse('$apiUrl/pets_vac/pet_vac_profile/$vacId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update pet vaccination profile');
      }
    } catch (e) {
      throw Exception('Error updating pet vaccination profile: $e');
    }
  }

  /// ลบข้อมูลวัคซีนของสัตว์เลี้ยง
  Future<void> deleteVaccinationProfile(int vacId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.delete(
        Uri.parse('$apiUrl/pets_vac/pet_vac_profile/$vacId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete pet vaccination profile');
      }
    } catch (e) {
      throw Exception('Error deleting pet vaccination profile: $e');
    }
  }
}
