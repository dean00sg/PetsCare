// models/feed_post.dart
class FeedPost {
  final String header;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final String imageUrl;
  final String description;

  FeedPost({
    required this.header,
    required this.startDatetime,
    required this.endDatetime,
    required this.imageUrl,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'header': header,
      'start_datetime': startDatetime.toIso8601String(),
      'end_datetime': endDatetime.toIso8601String(),
      'image_url': imageUrl,
      'description': description,
    };
  }
}
