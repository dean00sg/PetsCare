import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/users/event/create_pet_event.dart';
import 'package:frontend/users/repositories/petsgetall.dart';
import 'package:frontend/users/state/create_pet_state.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class CreatePetBloc extends Bloc<CreatePetEvent, CreatePetState> {
  final CreatePetRepository createPetRepository;

  CreatePetBloc({required this.createPetRepository}) : super(CreatePetInitial()) {
    on<SavePetProfile>((event, emit) async {
      emit(CreatePetLoading());

      try {
        await createPetRepository.createPet(event.petData);
        emit(CreatePetSuccess());
      } catch (error) {
        logger.e("Error creating pet: $error");
        emit(CreatePetFailure(error.toString()));
      }
    });
  }
}
