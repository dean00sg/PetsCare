import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/add_historyrec.dart'; 
import 'package:frontend/admin/state/add_historyrec.dart'; 
import 'package:frontend/admin/repositories/historyrec.dart'; 


class AddHistoryRecBloc extends Bloc<AddHistoryRecEvent, AddHistoryRecState> {
  final HistoryRepository repository;

  AddHistoryRecBloc(this.repository) : super(AddHistoryRecInitial()) {
    on<SubmitHistoryRecForm>(_onSubmitHistoryRecForm);
  }

  Future<void> _onSubmitHistoryRecForm(
    SubmitHistoryRecForm event,
    Emitter<AddHistoryRecState> emit,
  ) async {
    emit(AddHistoryRecLoading());
    try {
      await repository.createHistoryRecord(event.record);
      emit(AddHistoryRecSuccess());
    } catch (e) {
      emit(AddHistoryRecFailure(e.toString()));
    }
  }
}
