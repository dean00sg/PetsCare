import 'package:equatable/equatable.dart';
import 'package:frontend/models/login_model.dart'; // นำเข้า LoginModel

// กำหนด abstract class สำหรับ LoginEvent
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

// Event เมื่อกดปุ่ม Sign In
class LoginButtonPressed extends LoginEvent {
  final LoginModel loginData;

  const LoginButtonPressed(this.loginData);

  @override
  List<Object?> get props => [loginData];
}
