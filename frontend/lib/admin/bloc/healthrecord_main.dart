import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/healthrecord_main.dart';
import 'package:frontend/admin/state/healthrecord_main.dart';



class HealthrecordMainBloc extends Bloc<HealthrecordMainEvent, HealthrecordMainState> {
  HealthrecordMainBloc() : super(HealthrecordMainInitial()) {
  
    on<HealthrecordMainEvent>((event, emit) {
      emit(HealthrecordMainAddedState());
    });

    on<AddNewsFeedAdviceEvent>((event, emit) {
      emit(NewsFeedAdviceAddedState());
    });
  }
}
