abstract class NotificationUserEvent {}

class LoadNotificationsUser extends NotificationUserEvent {}
class LoadDeletedNotifications extends NotificationUserEvent {}

class DeleteNotificationUser extends NotificationUserEvent {
  final int notificationId;

  DeleteNotificationUser(this.notificationId);
}
