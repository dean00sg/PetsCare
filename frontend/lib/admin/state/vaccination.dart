import 'package:frontend/admin/models/vaccination.dart';

abstract class PetVacState {}

class PetVacInitial extends PetVacState {}

class PetVacLoading extends PetVacState {}

class PetVacLoaded extends PetVacState {
  final List<PetVacProfile> profiles;

  PetVacLoaded({required this.profiles});
}

class PetVacError extends PetVacState {
  final String message;

  PetVacError({required this.message});
}
