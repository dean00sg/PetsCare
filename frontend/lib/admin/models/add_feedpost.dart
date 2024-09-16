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
      'start_datetime': startDatetime.toIso8601String(), // แปลงเป็น ISO8601
      'end_datetime': endDatetime.toIso8601String(),     // แปลงเป็น ISO8601
      'image_url': imageUrl,
      'description': description,
    };
  }

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      header: json['header'],
      startDatetime: DateTime.parse(json['start_datetime']), // แปลงกลับจาก ISO8601
      endDatetime: DateTime.parse(json['end_datetime']),     // แปลงกลับจาก ISO8601
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
