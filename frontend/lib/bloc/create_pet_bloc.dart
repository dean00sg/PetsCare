import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/create_pet_event.dart';
import 'package:frontend/bloc/create_pet_state.dart';

class CreatePetBloc extends Bloc<CreatePetEvent, CreatePetState> {
  CreatePetBloc() : super(CreatePetInitial()) {
    // เมื่อ Event ของการกดปุ่มบันทึกถูกเรียกใช้
    on<SavePetProfile>((event, emit) async {
      emit(CreatePetLoading());

      try {
        // จำลองการบันทึกข้อมูลสัตว์เลี้ยง (เช่น การเชื่อมต่อกับฐานข้อมูล)
        await Future.delayed(const Duration(seconds: 2));

        // ถ้าสำเร็จให้ส่งสถานะ CreatePetSuccess
        emit(CreatePetSuccess());
      } catch (error) {
        // ถ้าเกิดข้อผิดพลาดในการบันทึก
        emit(CreatePetFailure(error.toString()));
      }
    });
  }
}
