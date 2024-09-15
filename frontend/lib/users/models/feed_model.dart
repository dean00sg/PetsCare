// Model for fetching a FeedPost (used in GET request)
class FeedPost {
  int ntId;
  String header;
  DateTime startDatetime;
  DateTime endDatetime;
  String? imageUrl;
  dynamic description;
  DateTime recordDate;

  FeedPost({
    required this.ntId,
    required this.header,
    required this.startDatetime,
    required this.endDatetime,
    this.imageUrl,
    this.description,
    required this.recordDate,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      ntId: json['NT_id'],
      header: json['header'],
      startDatetime: DateTime.parse(json['start_datetime']),
      endDatetime: DateTime.parse(json['end_datetime']),
      imageUrl: json['image_url'],
      description: json['description'],
      recordDate: DateTime.parse(json['record_date']),
    );
  }
}
