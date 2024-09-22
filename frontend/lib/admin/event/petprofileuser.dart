import 'package:frontend/admin/models/petprofileuser.dart';

abstract class PetProfileUserEvent {}

class FetchPetsEvent extends PetProfileUserEvent {}

class CreatePetUserEvent extends PetProfileUserEvent {
  final PetProfileUserModel petData;

  CreatePetUserEvent(this.petData);
}
