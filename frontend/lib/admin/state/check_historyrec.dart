import 'package:equatable/equatable.dart';
import 'package:frontend/admin/models/historyrec.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryRecord> historyRecords;

  HistoryLoaded({required this.historyRecords});

  @override
  List<Object> get props => [historyRecords];
}

class HistoryError extends HistoryState {
  final String error;

  HistoryError({required this.error});

  @override
  List<Object> get props => [error];
}
