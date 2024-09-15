import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;

  ProfileLoaded({required this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
