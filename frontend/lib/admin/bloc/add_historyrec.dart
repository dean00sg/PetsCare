import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/add_historyrec.dart'; // Update to your event
import 'package:frontend/admin/state/add_historyrec.dart'; // Update to your state
import 'package:frontend/admin/repositories/historyrec.dart'; // History record repo

class AddHistoryRecBloc extends Bloc<AddHistoryRecEvent, AddHistoryRecState> {
  final HistoryRepository repository;

  AddHistoryRecBloc({required this.repository}) : super(AddHistoryRecInitial()) {
    on<SubmitHistoryRecForm>(_onSubmitHistoryRecForm);
  }

  Future<void> _onSubmitHistoryRecForm(
    SubmitHistoryRecForm event,
    Emitter<AddHistoryRecState> emit,
  ) async {
    emit(AddHistoryRecLoading());

    try {
      final createdRecord = await repository.createHistoryRecord(event.record);
      emit(AddHistoryRecSuccess(createdRecord: createdRecord));
    } catch (error) {
      emit(AddHistoryRecFailure(error: error.toString()));
    }
  }
}
