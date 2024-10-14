import 'dart:convert';
import 'package:frontend/admin/models/add_notification.dart';
import 'package:frontend/admin/models/user.dart';
import 'package:frontend/users/models/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddNotificationUserRepository {
  final String apiUrl;

  AddNotificationUserRepository({required this.apiUrl});

  Future<void> postNotification(AddNotificationUserModel notification) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/Notification/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'header': notification.header,
        'to_user': notification.toUser,
        'start_noti': notification.startNoti.toIso8601String(),
        'end_noti': notification.endNoti.toIso8601String(),
        'file': notification.file,
        'detail': notification.detail,
      }),
    );

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to post notification');
    }
  }
}
class UserListRepository {
  final String apiUrl = 'https://pets-care.onrender.com/admin_manage/';

  Future<List<UserProfilePets>> getProfile() async {
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
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserProfilePets.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user profiles');
    }
  }
}

class ProfileNotiRepository {
  final String apiUrl;

  ProfileNotiRepository({required this.apiUrl});

  Future<UserProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/profile/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized, please log in again');
    } else {
      throw Exception('Failed to load profile');
    }
  }
}