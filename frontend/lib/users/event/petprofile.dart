import 'package:frontend/users/models/petprofile.dart';

abstract class PetProfileEvent {}

class LoadPetProfile extends PetProfileEvent {
  final String petsId;

  LoadPetProfile(this.petsId);
}

class UpdatePetProfile extends PetProfileEvent {
  final PetProfile petProfile;

  UpdatePetProfile(this.petProfile);
}
