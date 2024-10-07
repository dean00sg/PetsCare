import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/petprofile.dart';
import 'package:frontend/users/repositories/healthrec.dart';
import 'package:frontend/users/repositories/petprofile.dart';
import 'package:frontend/users/state/petprofile.dart';

class PetProfileBloc extends Bloc<PetProfileEvent, PetProfileState> {
  final PetProfileRepository petProfileRepository;
  final HealthRecordUserRepository healthRecordRepository;

  PetProfileBloc(this.petProfileRepository, this.healthRecordRepository)
      : super(PetProfileInitial()) {
    on<LoadPetProfile>((event, emit) async {
      emit(PetProfileLoading());
      try {
        final petProfile = await petProfileRepository.fetchPetByName(event.petsId);
        final healthRecords = await healthRecordRepository.fetchHealthRecords();

        emit(PetProfileLoaded(petProfile, healthRecords));
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
        emit(PetProfileLoaded(updatedProfile, []));
      } catch (error) {
        emit(PetProfileError(error.toString()));
      }
    });
  }
}
