import 'package:equatable/equatable.dart';

// กำหนด abstract class สำหรับ LoginState
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

// State เริ่มต้น
class LoginInitial extends LoginState {}

// State กำลังโหลด (เมื่อมีการกดปุ่ม Sign In)
class LoginLoading extends LoginState {}

// State เมื่อเข้าสู่ระบบสำเร็จ
class LoginSuccess extends LoginState {}

// State เมื่อเกิดข้อผิดพลาดในการเข้าสู่ระบบ
class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}
