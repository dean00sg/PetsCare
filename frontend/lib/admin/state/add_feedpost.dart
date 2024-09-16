// state/feed_state.dart
abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedSuccess extends FeedState {}

class FeedFailure extends FeedState {
  final String error;

  FeedFailure(this.error);
}
