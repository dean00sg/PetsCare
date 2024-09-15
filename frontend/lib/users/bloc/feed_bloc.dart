import 'package:flutter_bloc/flutter_bloc.dart';
import '../event/feed_event.dart';
import '../state/feed_state.dart';
import '../repositories/feed_repository.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepository;

  FeedBloc({required this.feedRepository}) : super(FeedInitial()) {
    on<FetchFeedData>(_onFetchFeedData);
  }

  void _onFetchFeedData(FetchFeedData event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      final feedPosts = await feedRepository.fetchFeedPosts();
      emit(FeedLoaded(feedPosts));
    } catch (e) {
      emit(const FeedError('Failed to load feed posts.'));
    }
  }
}
