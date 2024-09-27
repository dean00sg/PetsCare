import 'package:bloc/bloc.dart';
import 'package:frontend/admin/event/add_healthrec.dart';

import 'package:frontend/admin/repositories/chechhealth_rec.dart';
import 'package:frontend/admin/state/add_healthrec.dart';

class AddHealthRecordBloc extends Bloc<AddHealthRecordEvent, AddHealthRecordState> {
  final HealthRecordRepository repository;

  AddHealthRecordBloc(this.repository) : super(HealthRecordInitial()) {
    on<SubmitHealthRecord>(_onSubmitHealthRecord);
  }

  Future<void> _onSubmitHealthRecord(
      SubmitHealthRecord event, Emitter<AddHealthRecordState> emit) async {
    emit(HealthRecordSubmitting());
    try {
      // No need to capture the return since it's now Future<void>
      await repository.addHealthRecord(event.healthRecord);
      emit(HealthRecordSubmitted()); // Success state without returning a record
    } catch (e) {
      emit(HealthRecordError(e.toString()));
    }
  }
}
