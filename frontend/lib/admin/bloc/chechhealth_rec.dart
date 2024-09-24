import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/event/chechhealth_rec.dart';
import 'package:frontend/admin/repositories/chechhealth_rec.dart';
import 'package:frontend/admin/state/chechhealth_rec.dart';

class HealthRecordBloc extends Bloc<HealthRecordEvent, HealthRecordState> {
  final HealthRecordRepository repository;

  HealthRecordBloc(this.repository) : super(HealthRecordInitial()) {
    on<FetchHealthRecords>(_onFetchHealthRecords);
  }

  Future<void> _onFetchHealthRecords(
    FetchHealthRecords event,
    Emitter<HealthRecordState> emit,
  ) async {
    emit(HealthRecordLoading());

    try {
      final records = await repository.fetchHealthRecords();
      emit(HealthRecordLoaded(records));
    } catch (e) {
      emit(HealthRecordError(e.toString()));
    }
  }
}
