import 'package:frontend/users/models/petprofile.dart';

abstract class EditPetProfileState {}

class EditPetProfileInitial extends EditPetProfileState {}

class EditPetProfileUpdating extends EditPetProfileState {}

class EditPetProfileUpdated extends EditPetProfileState {
  final PetProfile petProfile;

  EditPetProfileUpdated(this.petProfile);
}

class EditPetProfileUpdateError extends EditPetProfileState {
  final String error;

  EditPetProfileUpdateError(this.error);
}
