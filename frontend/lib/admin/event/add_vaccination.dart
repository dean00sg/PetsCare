import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/vaccination.dart';

abstract class AddVaccinationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitVaccinationForm extends AddVaccinationEvent {
  final AddPetVacProfile profile;

  SubmitVaccinationForm(this.profile);

  @override
  List<Object?> get props => [profile];
}
