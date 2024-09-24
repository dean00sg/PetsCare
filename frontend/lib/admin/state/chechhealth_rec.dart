import 'package:frontend/admin/models/chechhealth_rec.dart';

abstract class HealthRecordState {}

class HealthRecordInitial extends HealthRecordState {}

class HealthRecordLoading extends HealthRecordState {}

class HealthRecordLoaded extends HealthRecordState {
  final List<HealthRecord> healthRecords;

  HealthRecordLoaded(this.healthRecords);
}

class HealthRecordError extends HealthRecordState {
  final String error;

  HealthRecordError(this.error);
}
