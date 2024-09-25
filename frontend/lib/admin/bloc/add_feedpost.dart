import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/add_feedpost.dart';
import 'package:frontend/admin/repositories/add_feedpost.dart';
import 'package:frontend/admin/state/add_feedpost.dart';

class AddFeedBloc extends Bloc<AddFeedPostEvent, FeedState> {
  final AddFeedRepository repository;

  AddFeedBloc({required this.repository}) : super(FeedInitial()) {
    on<AddFeedPostEvent>(_onAddFeedPost);
  }

  Future<void> _onAddFeedPost(AddFeedPostEvent event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      final addedPost = await repository.addFeedPost(event.post); // Await backend response
      emit(FeedSuccess(addedPost)); // Emit success state with added post
    } catch (e) {
      emit(FeedFailure(e.toString())); // Emit failure state
    }
  }
}
