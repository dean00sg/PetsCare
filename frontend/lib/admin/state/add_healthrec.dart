import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/chechhealth_rec.dart';

abstract class AddHealthRecordState extends Equatable {
  const AddHealthRecordState();

  @override
  List<Object> get props => [];
}

class HealthRecordInitial extends AddHealthRecordState {}

class HealthRecordSubmitting extends AddHealthRecordState {}

class HealthRecordSubmitted extends AddHealthRecordState {
  final HealthRecord healthRecord;

  const HealthRecordSubmitted(this.healthRecord);

  @override
  List<Object> get props => [healthRecord];
}

class HealthRecordError extends AddHealthRecordState {
  final String error;

  const HealthRecordError(this.error);

  @override
  List<Object> get props => [error];
}
