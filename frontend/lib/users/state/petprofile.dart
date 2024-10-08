
import 'package:frontend/users/models/healthrec.dart';
import 'package:frontend/users/models/petprofile.dart';

abstract class PetProfileState {}

class PetProfileInitial extends PetProfileState {}

class PetProfileLoading extends PetProfileState {}

class PetProfileLoaded extends PetProfileState {
  final PetProfile petProfile;
  final List<HealthRecordUser> healthRecords;

  PetProfileLoaded(this.petProfile, this.healthRecords);
}

class PetProfileError extends PetProfileState {
  final String error;

  PetProfileError(this.error);
}

class PetProfileUpdated extends PetProfileState {}
