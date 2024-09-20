import 'package:frontend/admin/models/add_feedpost.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; 

class AddFeedRepository {
  final String apiUrl = 'http://10.0.2.2:8000/feedpost/';

  Future<FeedPost> addFeedPost(FeedPost feedPostData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('No valid token found');
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode(feedPostData.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return FeedPost.fromJson(data);
    } else {
      throw Exception('Failed to add feed post: ${response.body}');
    }
  }
}
