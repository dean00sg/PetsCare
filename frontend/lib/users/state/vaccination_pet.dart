import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/vaccination_pet.dart';

abstract class PetVacUserState extends Equatable {
  const PetVacUserState();

  @override
  List<Object> get props => [];
}

class PetVacUserInitial extends PetVacUserState {}

class PetVacUserLoading extends PetVacUserState {}

class PetVacUserLoaded extends PetVacUserState {
  final List<PetVacUserProfile> vacUserProfiles;

  const PetVacUserLoaded(this.vacUserProfiles);

  @override
  List<Object> get props => [vacUserProfiles];
}

class PetVacUserError extends PetVacUserState {
  final String error;

  const PetVacUserError(this.error);

  @override
  List<Object> get props => [error];
}
