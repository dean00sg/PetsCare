import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/login_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final LoginModel loginData;

  const LoginButtonPressed(this.loginData);

  @override
  List<Object?> get props => [loginData];
}
