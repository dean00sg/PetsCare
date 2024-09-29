import 'package:equatable/equatable.dart';

abstract class PetVacUserEvent extends Equatable {
  const PetVacUserEvent();

  @override
  List<Object> get props => [];
}

class LoadPetVacUserProfile extends PetVacUserEvent {
  final String petsId;

  const LoadPetVacUserProfile(this.petsId);

  @override
  List<Object> get props => [petsId];
}
