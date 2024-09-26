import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/historyrec_main.dart';
import 'package:frontend/admin/state/historyrec_main.dart';


class HistoryRecMainBloc extends Bloc<HistoryRecMainEvent, HistoryRecMainState> {
  HistoryRecMainBloc() : super(HistoryRecMainInitial()) {
  
    on<HistoryRecMainEvent>((event, emit) {
      emit(HistoryRecMainAddedState());
    });

    // Removed AddNewsFeedAdviceEvent
  }
}
