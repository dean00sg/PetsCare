import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/create_pet_model.dart';

abstract class CreatePetState extends Equatable {
  const CreatePetState();

  @override
  List<Object?> get props => [];
}

//State เริ่มต้น
class CreatePetInitial extends CreatePetState {}

class CreatePetLoading extends CreatePetState {}

class CreatePetSuccess extends CreatePetState {}

class CreatePetUpdatedSuccess extends CreatePetState {
  final PetModel updatedPet;

  const CreatePetUpdatedSuccess({required this.updatedPet});

  @override
  List<Object?> get props => [updatedPet];
}

class CreatePetFailure extends CreatePetState {
  final String error;

  const CreatePetFailure(this.error);

  @override
  List<Object?> get props => [error];
}
