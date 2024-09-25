import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/vaccination_main.dart';
import 'package:frontend/admin/state/vaccination_main.dart';

class VaccinationMainBloc extends Bloc<VaccinationMainEvent, VaccinationMainState> {
  VaccinationMainBloc() : super(VaccinationMainInitial()) {
  
    on<VaccinationMainEvent>((event, emit) {
      emit(VaccinationMainAddedState());
    });

    // Removed AddNewsFeedAdviceEvent
  }
}
