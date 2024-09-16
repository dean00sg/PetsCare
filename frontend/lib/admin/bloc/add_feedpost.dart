// bloc/feed_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/add_feedpost.dart';
import 'package:frontend/admin/repositories/add_feedpost.dart';
import 'package:frontend/admin/state/add_feedpost.dart';


class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository repository;

  FeedBloc({required this.repository}) : super(FeedInitial()) {
    // Use on<Event> instead of mapEventToState
    on<AddFeedPostEvent>(_onAddFeedPost);
  }

  // Define the event handler for AddFeedPostEvent
  Future<void> _onAddFeedPost(AddFeedPostEvent event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      await repository.addFeedPost(event.post);
      emit(FeedSuccess());
    } catch (e) {
      emit(FeedFailure(e.toString()));
    }
  }
}