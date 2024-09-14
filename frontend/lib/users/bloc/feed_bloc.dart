import 'package:flutter_bloc/flutter_bloc.dart';
import '../event/feed_event.dart';
import '../state/feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc() : super(FeedInitial()) {
    on<FetchFeedData>(_onFetchFeedData);
  }

  void _onFetchFeedData(FetchFeedData event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      // เรียกข้อมูลจาก API หรือฐานข้อมูล
      await Future.delayed(const Duration(seconds: 2)); // สมมุติว่าใช้เวลานานในการดึงข้อมูล
      List<String> articles = ['บทความ 1', 'บทความ 2', 'บทความ 3']; // สมมุติข้อมูล
      emit(FeedLoaded(articles));
    } catch (e) {
      emit(const FeedError('Failed to load feed.'));
    }
  }
}
