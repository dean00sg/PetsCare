import 'package:equatable/equatable.dart';

abstract class AdminCheckInfoState extends Equatable {
  @override
  List<Object> get props => [];
}

class AdminCheckInfoInitial extends AdminCheckInfoState {}

class CheckingAllUsersState extends AdminCheckInfoState {}

class CheckingUsersByNameState extends AdminCheckInfoState {}

class CheckingOwnersOfPetsState extends AdminCheckInfoState {}

class CheckingVaccinesOfPetsState extends AdminCheckInfoState {}
