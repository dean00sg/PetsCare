import 'package:frontend/admin/models/petprofile.dart';

abstract class PetProfileEvent {}

class FetchPetsEvent extends PetProfileEvent {}

class CreatePetEvent extends PetProfileEvent {
  final PetProfileModel petData;

  CreatePetEvent(this.petData);
}
