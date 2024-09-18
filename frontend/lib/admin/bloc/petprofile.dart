import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/petprofile.dart';
import 'package:frontend/admin/repositories/petprofile.dart';
import 'package:frontend/admin/state/petprofile.dart';

class PetProfileBloc extends Bloc<PetProfileEvent, PetProfileState> {
  final PetProfileRepository petRepository;

  PetProfileBloc(this.petRepository) : super(PetInitialState()) {
    on<FetchPetsEvent>(_onFetchPets);
    on<CreatePetEvent>(_onCreatePet);
  }

  Future<void> _onFetchPets(
    FetchPetsEvent event,
    Emitter<PetProfileState> emit,
  ) async {
    emit(PetLoadingState());
    try {
      final pets = await petRepository.fetchPets();
      emit(PetLoadedState(pets));
    } catch (e) {
      emit(PetErrorState(e.toString()));
    }
  }

  Future<void> _onCreatePet(
    CreatePetEvent event,
    Emitter<PetProfileState> emit,
  ) async {
    emit(PetLoadingState());
    try {
      await petRepository.createPet(event.petData);
      emit(PetCreatedState());
      // Re-fetch pets after creating
      add(FetchPetsEvent());
    } catch (e) {
      emit(PetErrorState(e.toString()));
    }
  }
}
