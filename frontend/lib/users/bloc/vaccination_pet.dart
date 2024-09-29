import 'package:bloc/bloc.dart';
import 'package:frontend/users/event/vaccination_pet.dart';
import 'package:frontend/users/repositories/vaccination_pet.dart';
import 'package:frontend/users/state/vaccination_pet.dart';

class PetVacUserBloc extends Bloc<PetVacUserEvent, PetVacUserState> {
  final PetVacUserRepository petVacRepository;

  PetVacUserBloc(this.petVacRepository) : super(PetVacUserInitial()) {
    on<LoadPetVacUserProfile>((event, emit) async {
      emit(PetVacUserLoading());
      try {
        final vacProfileList = await petVacRepository.fetchPetById(event.petsId);
        emit(PetVacUserLoaded(vacProfileList));
      } catch (e) {
        emit(PetVacUserError(e.toString()));
      }
    });
  }
}
