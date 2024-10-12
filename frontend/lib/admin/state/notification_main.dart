import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationAddedState extends NotificationState {}

class NewsFeedAdviceAddedState extends NotificationState {}
