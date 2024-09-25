import 'package:frontend/users/models/petprofile.dart';

abstract class PetProfileState {}

class PetProfileInitial extends PetProfileState {}

class PetProfileLoading extends PetProfileState {}

class PetProfileLoaded extends PetProfileState {
  final PetProfile petProfile;

  PetProfileLoaded(this.petProfile);
}

class PetProfileUpdated extends PetProfileState {}

class PetProfileError extends PetProfileState {
  final String error;

  PetProfileError(this.error);
}
