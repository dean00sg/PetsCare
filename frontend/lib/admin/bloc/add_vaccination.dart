import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/add_vaccination.dart';
import 'package:frontend/admin/repositories/vaccination.dart';
import 'package:frontend/admin/state/add_vaccination.dart';

class AddVaccinationBloc extends Bloc<AddVaccinationEvent, AddVaccinationState> {
  final PetVacRepository repository;

  AddVaccinationBloc(this.repository) : super(AddVaccinationInitial()) {
    on<SubmitVaccinationForm>(_onSubmitVaccinationForm);
  }

  Future<void> _onSubmitVaccinationForm(
    SubmitVaccinationForm event,
    Emitter<AddVaccinationState> emit,
  ) async {
    emit(AddVaccinationLoading());
    try {
      await repository.createPetVacProfile(event.profile);
      emit(AddVaccinationSuccess());
    } catch (e) {
      emit(AddVaccinationFailure(e.toString()));
    }
  }
}
