import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/models/pet_models.dart';
import 'package:frontend/users/event/pet_event.dart';
import 'package:frontend/users/state/pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  PetBloc() : super(PetInitial()) {
    on<LoadPets>(_onLoadPets);
    on<SelectPet>(_onSelectPet);
  }

  void _onLoadPets(LoadPets event, Emitter<PetState> emit) async {
    emit(PetLoading());
    try {
      // จำลองการดึงข้อมูล
      final List<Pet> pets = [
        Pet(name: 'Cat', imagePath: 'lib/images/cat_icon.png'),
        Pet(name: 'Dog', imagePath: 'lib/images/dog_icon.png'),
        Pet(name: 'Rabbit', imagePath: 'lib/images/rabbit_icon.png'),
        Pet(name: 'Fish', imagePath: 'lib/images/fish_icon.png'),
      ];
      emit(PetLoaded(pets));
    } catch (e) {
      emit(const PetError("Failed to load pets"));
    }
  }

  void _onSelectPet(SelectPet event, Emitter<PetState> emit) {
    emit(PetSelected(event.pet));
  }
}
