import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/notification.dart';
import 'package:frontend/users/repositories/notification.dart';
import 'package:frontend/users/state/notification.dart';

class NotificationUserBloc extends Bloc<NotificationUserEvent, NotificationUserState> {
  final NotificationUserRepository notificationRepository;

  NotificationUserBloc({required this.notificationRepository}) 
      : super(NotificationInitial()) {
    on<LoadNotificationsUser>((event, emit) async {
      emit(NotificationLoading());

      try {
        // Fetch notifications without needing to pass the token from here
        final notifications = await notificationRepository.fetchNotificationsUser();
        emit(NotificationLoaded(notifications));
      } catch (error) {
        emit(NotificationUserError(error.toString()));
      }
    });
  }
}
