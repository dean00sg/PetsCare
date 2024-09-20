import 'dart:convert';
import 'package:frontend/users/models/feed_model.dart';
import 'package:http/http.dart' as http;

class FeedRepository {
  final String apiUrl;

  FeedRepository({required this.apiUrl});

  Future<List<FeedPost>> fetchFeedPosts() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/feedpost/'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => FeedPost.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to load feed posts');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }
}
