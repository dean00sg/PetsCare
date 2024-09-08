import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/signup_model.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final SignupModel user;

  SignupSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure({required this.error});

  @override
  List<Object> get props => [error];
}
