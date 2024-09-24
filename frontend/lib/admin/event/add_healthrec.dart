import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/chechhealth_rec.dart';

abstract class AddHealthRecordEvent extends Equatable {
  const AddHealthRecordEvent();

  @override
  List<Object> get props => [];
}

class SubmitHealthRecord extends AddHealthRecordEvent {
  final HealthRecord healthRecord;

  const SubmitHealthRecord(this.healthRecord);

  @override
  List<Object> get props => [healthRecord];
}
