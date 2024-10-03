import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/historyrec_pet.dart';

abstract class HistoryRecUserState extends Equatable {
  const HistoryRecUserState();

  @override
  List<Object> get props => [];
}

class HistoryRecUserInitial extends HistoryRecUserState {}

class HistoryRecUserLoading extends HistoryRecUserState {}

class HistoryRecUserLoaded extends HistoryRecUserState {
  final List<HistoryRecUserModel> records;

  const HistoryRecUserLoaded(this.records);

  @override
  List<Object> get props => [records];
}

class HistoryRecUserError extends HistoryRecUserState {
  final String message;

  const HistoryRecUserError(this.message);

  @override
  List<Object> get props => [message];
}
