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
        final notifications = await notificationRepository.fetchNotificationsUser();
        emit(NotificationLoaded(notifications));
      } catch (error) {
        emit(NotificationUserError(error.toString()));
      }
    });

    on<DeleteNotificationUser>((event, emit) async {
      try {
        await notificationRepository.updateNotificationStatus(event.notificationId, 'hide');
        add(LoadNotificationsUser());
      } catch (error) {
        emit(NotificationUserError(error.toString()));
      }
    });
  }
}
