import 'package:equatable/equatable.dart';

// กำหนด abstract class สำหรับ CreatePetState
abstract class CreatePetState extends Equatable {
  const CreatePetState();

  @override
  List<Object?> get props => [];
}

// State เริ่มต้น
class CreatePetInitial extends CreatePetState {}

// State เมื่อการบันทึกโปรไฟล์สัตว์เลี้ยงกำลังดำเนินการ
class CreatePetLoading extends CreatePetState {}

// State เมื่อบันทึกโปรไฟล์สัตว์เลี้ยงสำเร็จ
class CreatePetSuccess extends CreatePetState {}

// State เมื่อบันทึกโปรไฟล์สัตว์เลี้ยงล้มเหลว
class CreatePetFailure extends CreatePetState {
  final String error;

  const CreatePetFailure(this.error);

  @override
  List<Object?> get props => [error];
}
