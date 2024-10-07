abstract class NotificationUserEvent {}

class LoadNotificationsUser extends NotificationUserEvent {}

class DeleteNotificationUser extends NotificationUserEvent {
  final int notificationId;

  DeleteNotificationUser(this.notificationId);
}
