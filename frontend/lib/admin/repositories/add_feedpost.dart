// repositories/feed_repository.dart
import 'package:frontend/admin/models/add_feedpost.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedRepository {
  final String apiUrl;

  FeedRepository({required this.apiUrl});

  Future<void> addFeedPost(FeedPost post) async {
    final response = await http.post(
      Uri.parse('$apiUrl/feed'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add feed post');
    }
  }
}


