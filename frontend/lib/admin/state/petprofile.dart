import 'package:frontend/admin/models/petprofile.dart';

abstract class PetProfileState {}

class PetInitialState extends PetProfileState {}

class PetLoadingState extends PetProfileState {}

class PetLoadedState extends PetProfileState {
  final List<PetProfileModel> pets;

  PetLoadedState(this.pets);
}

class PetErrorState extends PetProfileState {
  final String message;

  PetErrorState(this.message);
}

class PetCreatedState extends PetProfileState {}
