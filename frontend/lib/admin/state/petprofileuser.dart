import 'package:frontend/admin/models/petprofileuser.dart';

abstract class PetProfileUserState {}

class PetInitialUserState extends PetProfileUserState {}

class PetLoadingUserState extends PetProfileUserState {}

class PetLoadedUserState extends PetProfileUserState {
  final List<PetProfileUserModel> pets;

  PetLoadedUserState(this.pets);
}

class PetErrorUserState extends PetProfileUserState {
  final String message;

  PetErrorUserState(this.message);
}

class PetCreatedUserState extends PetProfileUserState {}
