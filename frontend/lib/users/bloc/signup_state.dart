import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/signup_model.dart';

// SignupState เป็น abstract class เพื่อให้ state อื่นๆ สืบทอดไปใช้
abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

// State เริ่มต้น
class SignupInitial extends SignupState {}

// State สำหรับการโหลด
class SignupLoading extends SignupState {}

// State เมื่อสมัครสมาชิกสำเร็จ
class SignupSuccess extends SignupState {
  final SignupModel user;

  const SignupSuccess({required this.user});
}

// State เมื่อสมัครสมาชิกล้มเหลว
class SignupFailure extends SignupState {
  final String error;

  const SignupFailure(this.error);

  @override
  List<Object?> get props => [error];
}

