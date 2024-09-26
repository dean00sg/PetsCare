import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/check_historyrec.dart';
import 'package:frontend/admin/repositories/historyrec.dart';
import 'package:frontend/admin/state/check_historyrec.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository repository;

  HistoryBloc({required this.repository}) : super(HistoryInitial()) {
    on<FetchHistoryRecords>(_onFetchHistoryRecords);
  }

  Future<void> _onFetchHistoryRecords(
      FetchHistoryRecords event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final records = await repository.fetchHistoryRecords();
      emit(HistoryLoaded(historyRecords: records));
    } catch (e) {
      emit(HistoryError(error: e.toString()));
    }
  }
}
