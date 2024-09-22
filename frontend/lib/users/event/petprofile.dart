abstract class PetProfileEvent {}

class LoadPetProfile extends PetProfileEvent {
  final String petName;

  LoadPetProfile(this.petName);
}
