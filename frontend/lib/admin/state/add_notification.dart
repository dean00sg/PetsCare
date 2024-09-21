import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/user.dart';

abstract class AddNotificationState extends Equatable {
  const AddNotificationState();

  @override
  List<Object?> get props => [];
}

class AddNotificationInitial extends AddNotificationState {}

class AddNotificationLoading extends AddNotificationState {}

class AddNotificationSuccess extends AddNotificationState {}

class AddNotificationFailure extends AddNotificationState {
  final String error;

  const AddNotificationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UsersLoadedForNotification extends AddNotificationState {
  final List<UserProfilePets> users;

  const UsersLoadedForNotification({required this.users});

  @override
  List<Object?> get props => [users];
}
