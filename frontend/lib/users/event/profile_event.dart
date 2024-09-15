import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  UpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, phone];
}
