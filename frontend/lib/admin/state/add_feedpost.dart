import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/add_feedpost.dart';


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

// Success state after a post is added
class FeedSuccess extends FeedState {
  final FeedPost feedPost;

  const FeedSuccess(this.feedPost);

  @override
  List<Object> get props => [feedPost];
}

class FeedFailure extends FeedState {
  final String error;

  const FeedFailure(this.error);

  @override
  List<Object> get props => [error];
}
