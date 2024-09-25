import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/vaccination.dart';
import 'package:frontend/admin/repositories/vaccination.dart';
import 'package:frontend/admin/state/vaccination.dart';

class PetVacBloc extends Bloc<PetVacEvent, PetVacState> {
  final PetVacRepository petVacRepository;

  PetVacBloc({required this.petVacRepository}) : super(PetVacInitial()) {
    on<FetchPetVacProfiles>((event, emit) async {
      emit(PetVacLoading());
      try {
        final profiles = await petVacRepository.fetchPetVacProfiles();
        emit(PetVacLoaded(profiles: profiles));
      } catch (e) {
        emit(PetVacError(message: e.toString()));
      }
    });
  }
}

