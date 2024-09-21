import 'package:frontend/users/models/notification.dart';

abstract class NotificationUserState {}

class NotificationInitial extends NotificationUserState {}

class NotificationLoading extends NotificationUserState {}

class NotificationLoaded extends NotificationUserState {
  final List<NotificationUserModel> notifications;

  NotificationLoaded(this.notifications);
}

class NotificationUserError extends NotificationUserState {
  final String message;

  NotificationUserError(this.message);
}
