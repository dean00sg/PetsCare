import 'package:equatable/equatable.dart';

abstract class AddVaccinationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddVaccinationInitial extends AddVaccinationState {}

class AddVaccinationLoading extends AddVaccinationState {}

class AddVaccinationSuccess extends AddVaccinationState {}

class AddVaccinationFailure extends AddVaccinationState {
  final String error;

  AddVaccinationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
