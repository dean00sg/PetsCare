import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/signup_event.dart';
import 'package:frontend/bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    // การจัดการเมื่อ event SignupButtonPressed ถูกเรียก
    on<SignupButtonPressed>((event, emit) async {
      emit(SignupLoading()); // เริ่มต้นด้วยการแสดงสถานะการโหลด

      try {
        // ตัวอย่างการสมัครสมาชิก (คุณสามารถเชื่อมต่อกับ API หรือฐานข้อมูลตรงนี้)
        await Future.delayed(const Duration(seconds: 2)); // จำลองการสมัครสมาชิก

        // ถ้าสำเร็จให้ส่งสถานะ SignupSuccess
        emit(SignupSuccess());
      } catch (error) {
        // ถ้าล้มเหลวให้ส่งสถานะ SignupFailure พร้อมข้อความแสดงข้อผิดพลาด
        emit(SignupFailure(error.toString()));
      }
    });
  }
}
