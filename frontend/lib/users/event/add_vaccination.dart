import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/vaccination_pet.dart';

abstract class VaccinationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddVaccinationEvent extends VaccinationEvent {
  final AddPetVacProfile profile;

  AddVaccinationEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}
