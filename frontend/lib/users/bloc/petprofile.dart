import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/petprofile.dart';
import 'package:frontend/users/repositories/petprofile.dart';
import 'package:frontend/users/state/petprofile.dart';

class PetProfileBloc extends Bloc<PetProfileEvent, PetProfileState> {
  final PetProfileRepository petProfileRepository;

  PetProfileBloc(this.petProfileRepository) : super(PetProfileInitial()) {
    on<LoadPetProfile>((event, emit) async {
      emit(PetProfileLoading());
      try {
        final petProfile = await petProfileRepository.fetchPetByName(event.petsId);
        emit(PetProfileLoaded(petProfile));
      } catch (error) {
        emit(PetProfileError(error.toString()));
      }
    });

    on<UpdatePetProfile>((event, emit) async {
      emit(PetProfileLoading());
      try {
        await petProfileRepository.updatePetProfile(event.petProfile.petsId.toString(), event.petProfile);
        emit(PetProfileUpdated());
        
        final updatedProfile = await petProfileRepository.fetchPetByName(event.petProfile.petsId.toString());
        emit(PetProfileLoaded(updatedProfile));
      } catch (error) {
        emit(PetProfileError(error.toString()));
      }
    });
  }
}
