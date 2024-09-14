import 'package:frontend/users/models/login_model.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final LoginModel loginData;

  LoginButtonPressed(this.loginData);
}
