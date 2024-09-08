import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/signup_model.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final SignupModel signupData;

  SignupButtonPressed({required this.signupData});

  @override
  List<Object> get props => [signupData];
}
