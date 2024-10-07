import 'package:equatable/equatable.dart';

abstract class VaccinationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VaccinationInitial extends VaccinationState {}

class VaccinationLoading extends VaccinationState {}

class VaccinationAdded extends VaccinationState {}

class VaccinationError extends VaccinationState {
  final String error;

  VaccinationError(this.error);

  @override
  List<Object?> get props => [error];
}
