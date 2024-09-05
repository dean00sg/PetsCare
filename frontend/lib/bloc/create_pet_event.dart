import 'package:equatable/equatable.dart';
import 'package:frontend/models/create_pat_model.dart';
 // นำเข้า PetModel

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
