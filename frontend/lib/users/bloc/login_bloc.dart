import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/login_event.dart';
import 'package:frontend/users/state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    // เมื่อ Event ของการกดปุ่ม Sign In ถูกเรียกใช้
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading()); // เปลี่ยนสถานะเป็นกำลังโหลด

      try {
        // รอให้การเข้าสู่ระบบเสร็จสมบูรณ์ (จำลองการเข้าสู่ระบบ)
        await Future.delayed(const Duration(seconds: 2));

        // ถ้าเข้าสู่ระบบสำเร็จ
        emit(LoginSuccess());
      } catch (error) {
        // ถ้าเกิดข้อผิดพลาดในการเข้าสู่ระบบ
        emit(LoginFailure(error.toString()));
      }
    });
  }
}
