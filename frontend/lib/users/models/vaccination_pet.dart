class PetVacUserProfile {
  final String status;
  final int vacId;
  final String vacName;
  final int dose;
  final String startDateVac;
  final String location;
  final String remark;
  final int petsId;
  final String petName;
  final String ownerName;
  final String noteBy;

  PetVacUserProfile({
    required this.status,
    required this.vacId,
    required this.vacName,
    required this.dose,
    required this.startDateVac,
    required this.location,
    required this.remark,
    required this.petsId,
    required this.petName,
    required this.ownerName,
    required this.noteBy,
  });

  factory PetVacUserProfile.fromJson(Map<String, dynamic> json) {
    return PetVacUserProfile(
      status: json['status'],
      vacId: json['vac_id'],
      vacName: json['vac_name'],
      dose: json['dose'],
      startDateVac: json['startdatevac'],
      location: json['location'],
      remark: json['remark'],
      petsId: json['pets_id'],
      petName: json['pet_name'],
      ownerName: json['owner_name'],
      noteBy: json['note_by'],
    );
  }
}
