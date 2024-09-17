import 'package:equatable/equatable.dart';

abstract class AdminCheckInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckAllUsersEvent extends AdminCheckInfoEvent {}

class CheckUsersByNameEvent extends AdminCheckInfoEvent {}

class CheckOwnersOfPetsEvent extends AdminCheckInfoEvent {}

class CheckVaccinesOfPetsEvent extends AdminCheckInfoEvent {}
