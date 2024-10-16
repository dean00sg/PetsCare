// bloc/notification_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/notification_main.dart';
import 'package:frontend/admin/state/notification_main.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<AddNotificationEvent>((event, emit) {
      emit(NotificationAddedState());
    });

    on<AddNewsFeedAdviceEvent>((event, emit) {
      emit(NewsFeedAdviceAddedState());
    });
  }
}
