import 'package:equatable/equatable.dart';

abstract class AddHealthRecordState extends Equatable {
  const AddHealthRecordState();

  @override
  List<Object> get props => [];
}

class HealthRecordInitial extends AddHealthRecordState {}

class HealthRecordSubmitting extends AddHealthRecordState {}

class HealthRecordSubmitted extends AddHealthRecordState {
  // No longer need to store HealthRecord in the success state
  @override
  List<Object> get props => [];
}

class HealthRecordError extends AddHealthRecordState {
  final String error;

  const HealthRecordError(this.error);

  @override
  List<Object> get props => [error];
}
