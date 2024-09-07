import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/signup_model.dart';

// Event สำหรับ Sign Up
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

// Event สำหรับกดปุ่ม Sign Up
class SignupButtonPressed extends SignupEvent {
  final SignupModel signupData;

  // กำหนด SignupModel ลงในตัวสร้าง
  const SignupButtonPressed({required this.signupData});

  @override
  List<Object?> get props => [signupData];
}
