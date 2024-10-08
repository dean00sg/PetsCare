import 'dart:convert';
import 'package:frontend/users/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationUserRepository {
  final String apiUrl;

  NotificationUserRepository({required this.apiUrl});

  Future<List<NotificationUserModel>> fetchNotificationsUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/Notification/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => NotificationUserModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized, please log in again');
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to load notifications');
    }
  }

  Future<void> updateNotificationStatus(int notificationId, String statusShow) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found, user not logged in');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/Notification/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'noti_id': notificationId,
        'status_show': statusShow,
      }),
    );

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to update notification');
    }
  }
}
