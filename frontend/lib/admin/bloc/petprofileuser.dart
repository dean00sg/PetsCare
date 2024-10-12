import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/petprofileuser.dart';
import 'package:frontend/admin/repositories/petprofileuser.dart';
import 'package:frontend/admin/state/petprofileuser.dart';

class PetProfileUserBloc extends Bloc<PetProfileUserEvent, PetProfileUserState> {
  final PetProfileUserRepository petRepository;

  PetProfileUserBloc(this.petRepository) : super(PetInitialUserState()) {
    on<FetchPetsEvent>(_onFetchPets);
    on<CreatePetUserEvent>(_onCreatePet);
  }

  Future<void> _onFetchPets(
    FetchPetsEvent event,
    Emitter<PetProfileUserState> emit,
  ) async {
    emit(PetLoadingUserState());
    try {
      final pets = await petRepository.fetchPets();
      emit(PetLoadedUserState(pets));
    } catch (e) {
      emit(PetErrorUserState(e.toString()));
    }
  }

  Future<void> _onCreatePet(
    CreatePetUserEvent event,
    Emitter<PetProfileUserState> emit,
  ) async {
    emit(PetLoadingUserState());
    try {
      await petRepository.createPet(event.petData);
      emit(PetCreatedUserState());
      //Re-fetch pets after creating
      add(FetchPetsEvent());
    } catch (e) {
      emit(PetErrorUserState(e.toString()));
    }
  }
}
