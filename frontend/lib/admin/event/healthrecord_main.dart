// events/notification_event.dart
import 'package:equatable/equatable.dart';

abstract class HealthrecordMainEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNotificationEvent extends HealthrecordMainEvent {}

class AddNewsFeedAdviceEvent extends HealthrecordMainEvent {}
