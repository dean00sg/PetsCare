import 'package:equatable/equatable.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<String> articles;

  const FeedLoaded(this.articles);

  @override
  List<Object> get props => [articles];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object> get props => [message];
}
