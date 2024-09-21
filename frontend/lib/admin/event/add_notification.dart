import 'package:equatable/equatable.dart';

abstract class AddNotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNotificationSubmitted extends AddNotificationEvent {
  final String header;
  final String toUser;
  final DateTime startNoti;
  final DateTime endNoti;
  final String file;
  final String detail;

  AddNotificationSubmitted({
    required this.header,
    required this.toUser,
    required this.startNoti,
    required this.endNoti,
    required this.file,
    required this.detail,
  });
}

class LoadUsersForNotification extends AddNotificationEvent {}
