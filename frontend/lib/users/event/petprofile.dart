import 'package:frontend/users/models/petprofile.dart';

abstract class PetProfileEvent {}

class LoadPetProfile extends PetProfileEvent {
  final String petName;

  LoadPetProfile(this.petName);
}

class UpdatePetProfile extends PetProfileEvent {
  final PetProfile updatedProfile;

  UpdatePetProfile(this.updatedProfile);
}