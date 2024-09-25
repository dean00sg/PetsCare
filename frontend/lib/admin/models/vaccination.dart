class PetVacProfile {
  final int vacId;
  final int dose;
  final String vacName;
  final DateTime startDateVac;
  final String location;
  final String remark;
  final String petName;
  final String ownerName;
  final String note_by;

  PetVacProfile({
    required this.vacId,
    required this.dose,
    required this.vacName,
    required this.startDateVac,
    required this.location,
    required this.remark,
    required this.petName,
    required this.ownerName,
    required this.note_by,
  });

  factory PetVacProfile.fromJson(Map<String, dynamic> json) {
    return PetVacProfile(
      vacId: json['vac_id'],
      dose: json['dose'],
      vacName: json['vac_name'],
      startDateVac: DateTime.parse(json['startdatevac']).toLocal(),
      location: json['location'],
      remark: json['remark'],
      petName: json['pet_name'],
      ownerName: json['owner_name'],
      note_by: json['note_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vac_id': vacId,
      'pet_name': petName,
      'owner_name': ownerName,
      'dose': dose,
      'vac_name': vacName,
      'startdatevac': startDateVac.toIso8601String().split('T').first,
      'location': location,
      'remark': remark,
    };
  }
}

class AddPetVacProfile {
  final int dose;
  final String vacName;
  final DateTime startDateVac;
  final String location;
  final String remark;
  final String petName;
  final String ownerName;
  final String note_by;


  AddPetVacProfile({
    required this.dose,
    required this.vacName,
    required this.startDateVac,
    required this.location,
    required this.remark,
    required this.petName,
    required this.ownerName,
    required this.note_by,
  });

  Map<String, dynamic> toJson() {
    return {
      'pet_name': petName,
      'owner_name': ownerName,
      'dose': dose,
      'vac_name': vacName,
      'startdatevac': startDateVac.toIso8601String().split('T').first, // Formatting date only
      'location': location,
      'remark': remark,
      'note_by': note_by,

    };
  }
}

