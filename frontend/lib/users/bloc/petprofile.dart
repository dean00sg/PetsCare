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
        final petProfile = await petProfileRepository.fetchPetByName(event.petName);
        emit(PetProfileLoaded(petProfile));
      } catch (error) {
        emit(PetProfileError(error.toString()));
      }
    });
  }
}
