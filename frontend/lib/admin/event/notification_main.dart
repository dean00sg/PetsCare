// events/notification_event.dart
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNotificationEvent extends NotificationEvent {}

class AddNewsFeedAdviceEvent extends NotificationEvent {}
