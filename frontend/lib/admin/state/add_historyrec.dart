import 'package:equatable/equatable.dart';

abstract class AddHistoryRecState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddHistoryRecInitial extends AddHistoryRecState {}

class AddHistoryRecLoading extends AddHistoryRecState {}

class AddHistoryRecSuccess extends AddHistoryRecState {}

class AddHistoryRecFailure extends AddHistoryRecState {
  final String error;

  AddHistoryRecFailure(this.error);

  @override
  List<Object?> get props => [error];
}
