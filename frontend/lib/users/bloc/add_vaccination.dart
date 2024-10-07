import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/add_vaccination.dart';
import 'package:frontend/users/repositories/vaccination.dart';
import 'package:frontend/users/state/add_vaccination.dart';

class VaccinationBloc extends Bloc<VaccinationEvent, VaccinationState> {
  final UserPetVacRepository repository;

  VaccinationBloc(this.repository) : super(VaccinationInitial()) {
    on<AddVaccinationEvent>(_onAddVaccination);
  }

  Future<void> _onAddVaccination(
    AddVaccinationEvent event,
    Emitter<VaccinationState> emit,
  ) async {
    emit(VaccinationLoading());
    try {
      await repository.createPetVacProfile(event.profile);
      emit(VaccinationAdded());
    } catch (e) {
      emit(VaccinationError(e.toString()));
    }
  }
}
