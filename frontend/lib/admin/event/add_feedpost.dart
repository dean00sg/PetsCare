import 'package:frontend/admin/models/add_feedpost.dart';

abstract class FeedEvent {}

class AddFeedPostEvent extends FeedEvent {
  final FeedPost post;

  AddFeedPostEvent(this.post);
}
