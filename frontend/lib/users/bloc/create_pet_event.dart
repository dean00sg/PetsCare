import 'package:equatable/equatable.dart';
import 'package:frontend/users/models/create_pet_model.dart';

abstract class CreatePetEvent extends Equatable {
  const CreatePetEvent();

  @override
  List<Object?> get props => [];
}

// Event สำหรับกดปุ่มบันทึก (Save)
class SavePetProfile extends CreatePetEvent {
  final PetModel petData;

  const SavePetProfile(this.petData);

  @override
  List<Object?> get props => [petData];
}

// Event สำหรับการแก้ไขโปรไฟล์สัตว์เลี้ยง (Update)
class UpdatePetProfile extends CreatePetEvent {
  final PetModel updatedPet;

  const UpdatePetProfile(this.updatedPet);

  @override
  List<Object?> get props => [updatedPet];
}
