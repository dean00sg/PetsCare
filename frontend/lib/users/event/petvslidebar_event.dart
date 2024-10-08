import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/petslidebar_models.dart';

abstract class PetEvent extends Equatable {
  const PetEvent();

  @override
  List<Object> get props => [];
}

class LoadPets extends PetEvent {}

class SelectPet extends PetEvent {
  final Pet pet;

  const SelectPet(this.pet);

  @override
  List<Object> get props => [pet];
}
