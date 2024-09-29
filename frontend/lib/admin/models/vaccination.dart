class PetVacProfile {
  final int vacId;
  final String vacName;
  final int dose;
  final DateTime startDateVac;
  final String location;
  final String remark;
  final int petsId;
  final String petName;
  final String ownerName;
  final String noteBy;

  PetVacProfile({
    required this.vacId,
    required this.dose,
    required this.vacName,
    required this.startDateVac,
    required this.location,
    required this.remark,
    required this.petsId,
    required this.petName,
    required this.ownerName,
    required this.noteBy,
  });

  factory PetVacProfile.fromJson(Map<String, dynamic> json) {
    return PetVacProfile(
      vacId: json['vac_id'],
      dose: json['dose'],
      vacName: json['vac_name'],
      startDateVac: DateTime.parse(json['startdatevac']),
      location: json['location'],
      remark: json['remark'],
      petsId: json['pets_id'],
      petName: json['pet_name'],
      ownerName: json['owner_name'],
      noteBy: json['note_by'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vac_id': vacId,
      'pets_id': petsId, 
      'pet_name': petName,
      'owner_name': ownerName,
      'dose': dose,
      'vac_name': vacName,
      'startdatevac': startDateVac, 
      'location': location,
      'remark': remark,
      'note_by': noteBy,
    };
  }
}


class AddPetVacProfile {
  final int dose;
  final String vacName;
  final DateTime startDateVac;
  final String location;
  final String remark;
  final int petsId;
  final String petName;
  final String ownerName;
  final String noteBy; // Changed to camelCase

  AddPetVacProfile({
    required this.dose,
    required this.vacName,
    required this.startDateVac,
    required this.location,
    required this.remark,
    required this.petsId,
    required this.petName,
    required this.ownerName,
    required this.noteBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'pets_id': petsId, // Match with API naming
      'pet_name': petName,
      'owner_name': ownerName,
      'dose': dose,
      'vac_name': vacName,
      'startdatevac': startDateVac.toIso8601String(),
      'location': location,
      'remark': remark,
      'note_by': noteBy, // Match with field
    };
  }
}
