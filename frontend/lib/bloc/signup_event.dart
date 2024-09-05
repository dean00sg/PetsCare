import 'package:equatable/equatable.dart';
import 'package:frontend/models/signup_model.dart';

// SignupEvent เป็น abstract class เพื่อให้ event อื่นๆ สืบทอดไปใช้
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

// Event สำหรับกดปุ่ม Sign Up
class SignupButtonPressed extends SignupEvent {
  final SignupModel signupData;

  const SignupButtonPressed(this.signupData);

  @override
  List<Object?> get props => [signupData];
}
