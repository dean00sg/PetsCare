import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserPetsLoaded extends UserState {
  final List<UserProfilePets> profiles;

  const UserPetsLoaded({required this.profiles});

  @override
  List<Object> get props => [profiles];
}

class UserLoadFailure extends UserState {}
