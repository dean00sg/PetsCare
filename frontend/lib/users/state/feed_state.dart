import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/feed_model.dart';


abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<FeedPost> feedPosts;

  const FeedLoaded(this.feedPosts);

  @override
  List<Object> get props => [feedPosts];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object> get props => [message];
}
