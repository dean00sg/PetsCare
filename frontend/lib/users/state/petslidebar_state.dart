import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/petslidebar_models.dart';

abstract class PetState extends Equatable {
  const PetState();

  @override
  List<Object> get props => [];
}

class PetInitial extends PetState {}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final List<Pet> pets;

  const PetLoaded(this.pets);

  @override
  List<Object> get props => [pets];
}

class PetSelected extends PetState {
  final Pet selectedPet;

  const PetSelected(this.selectedPet);

  @override
  List<Object> get props => [selectedPet.petsId]; 
}

class PetError extends PetState {
  final String error;

  const PetError(this.error);

  @override
  List<Object> get props => [error];
}
