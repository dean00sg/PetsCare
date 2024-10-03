import 'package:equatable/equatable.dart';

abstract class HistoryRecUserEvent extends Equatable {
  const HistoryRecUserEvent();

  @override
  List<Object> get props => [];
}

class LoadHistoryRecUser extends HistoryRecUserEvent {
  final String petsId;

  const LoadHistoryRecUser(this.petsId);

  @override
  List<Object> get props => [petsId];
}
