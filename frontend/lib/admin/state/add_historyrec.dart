import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/historyrec.dart';

abstract class AddHistoryRecState extends Equatable {
  const AddHistoryRecState();

  @override
  List<Object?> get props => [];
}

class AddHistoryRecInitial extends AddHistoryRecState {}

class AddHistoryRecLoading extends AddHistoryRecState {}

class AddHistoryRecSuccess extends AddHistoryRecState {
  final AddHistoryRec createdRecord;

  const AddHistoryRecSuccess({required this.createdRecord});

  @override
  List<Object?> get props => [createdRecord];
}

class AddHistoryRecFailure extends AddHistoryRecState {
  final String error;

  const AddHistoryRecFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
