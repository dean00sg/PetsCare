import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/historyrec_pet.dart';
import 'package:frontend/users/repositories/historyrec_pet.dart';
import 'package:frontend/users/state/historyrec_pet.dart';

class HistoryRecUserBloc extends Bloc<HistoryRecUserEvent, HistoryRecUserState> {
  final HistoryRecUserRepository repository;

  HistoryRecUserBloc(this.repository) : super(HistoryRecUserInitial()) {
    on<LoadHistoryRecUser>((event, emit) async {
      emit(HistoryRecUserLoading());
      try {
        final records = await repository.fetchPetById(event.petsId);
        emit(HistoryRecUserLoaded(records));
      } catch (e) {
        emit(HistoryRecUserError(e.toString()));
      }
    });
  }
}
