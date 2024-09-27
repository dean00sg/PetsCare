import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/models/petslidebar_models.dart';
import 'package:frontend/users/event/petvslidebar_event.dart';
import 'package:frontend/users/state/petslidebar_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  PetBloc() : super(PetInitial()) {
    on<LoadPets>(_onLoadPets);
    on<SelectPet>(_onSelectPet);
  }

  void _onLoadPets(LoadPets event, Emitter<PetState> emit) async {
    emit(PetLoading());
    try {
      // สร้างรายการสัตว์เลี้ยงที่มี petsId
      final List<Pet> pets = [
        Pet(petsId: 1, name: 'Cat', imagePath: 'lib/images/cat_icon.png'),
        Pet(petsId: 2, name: 'Dog', imagePath: 'lib/images/dog_icon.png'),
        Pet(petsId: 3, name: 'Rabbit', imagePath: 'lib/images/rabbit_icon.png'),
        Pet(petsId: 4, name: 'Fish', imagePath: 'lib/images/fish_icon.png'),
      ];
      emit(PetLoaded(pets));
    } catch (e) {
      emit(const PetError("Failed to load pets"));
    }
  }

  void _onSelectPet(SelectPet event, Emitter<PetState> emit) {
    emit(PetSelected(event.pet)); // ส่ง pet ที่ถูกเลือกไปยัง state
  }
}
