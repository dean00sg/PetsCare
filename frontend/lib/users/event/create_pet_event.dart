import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/create_pet_model.dart';

abstract class CreatePetEvent extends Equatable {
  const CreatePetEvent();

  @override
  List<Object?> get props => [];
}

class SavePetProfile extends CreatePetEvent {
  final PetModel petData;

  const SavePetProfile(this.petData);

  @override
  List<Object?> get props => [petData];
}
