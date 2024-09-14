import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/event/create_pet_event.dart';
import 'package:frontend/users/state/create_pet_state.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class CreatePetBloc extends Bloc<CreatePetEvent, CreatePetState> {
  CreatePetBloc() : super(CreatePetInitial()) {
    // เมื่อ Event ของการบันทึกโปรไฟล์สัตว์เลี้ยงถูกเรียกใช้
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

    // เมื่อ Event ของการแก้ไขโปรไฟล์สัตว์เลี้ยงถูกเรียกใช้
    on<UpdatePetProfile>((event, emit) async {
      emit(CreatePetLoading());

      try {
        logger.d("Updating pet profile with data: ${event.updatedPet}"); // ใช้ logger แทน print

        // จำลองการอัปเดตข้อมูลสัตว์เลี้ยง
        await Future.delayed(const Duration(seconds: 2));

        // ถ้าสำเร็จให้ส่งสถานะ CreatePetUpdatedSuccess
        emit(CreatePetUpdatedSuccess(updatedPet: event.updatedPet));
      } catch (error) {
        logger.e("Error updating pet profile: $error"); // ใช้ logger สำหรับแสดงข้อผิดพลาด
        emit(CreatePetFailure(error.toString()));
      }
    });
  }
}
