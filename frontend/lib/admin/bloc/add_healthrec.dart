import 'package:bloc/bloc.dart';
import 'package:frontend/admin/event/add_healthrec.dart';
import 'package:frontend/admin/models/chechhealth_rec.dart';
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
      final HealthRecord newRecord =
          await repository.addHealthRecord(event.healthRecord);
      emit(HealthRecordSubmitted(newRecord));
    } catch (e) {
      emit(HealthRecordError(e.toString()));
    }
  }
}
