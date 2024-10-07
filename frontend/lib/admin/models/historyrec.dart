class HistoryRecord {
  final int hrId;
  final String header;
  final DateTime recordDatetime;
  final String symptoms;
  final String diagnose;
  final String remark;
  final String petName;
  final String ownerName;
  final String noteBy;

  HistoryRecord({
    required this.hrId,
    required this.header,
    required this.recordDatetime,
    required this.symptoms,
    required this.diagnose,
    required this.remark,
    required this.petName,
    required this.ownerName,
    required this.noteBy,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      hrId: json['hr_id'],
      header: json['header'],
      recordDatetime: DateTime.parse(json['record_datetime']),
      symptoms: json['Symptoms'],
      diagnose: json['Diagnose'],
      remark: json['Remark'],
      petName: json['pet_name'],
      ownerName: json['owner_name'],
      noteBy: json['note_by'],
    );
  }
}

class AddHistoryRec {
  final String header;
  final String symptoms;
  final String diagnose;
  final String remark;
  final String pets_id;
  final String ownerName;

  AddHistoryRec({
    required this.header,
    required this.symptoms,
    required this.diagnose,
    required this.remark,
    required this.pets_id,
    required this.ownerName,
  });

  Map<String, dynamic> toJson() => {
        "header": header,
        "Symptoms": symptoms,
        "Diagnose": diagnose,
        "Remark": remark,
        "pets_id": pets_id,
        "owner_name": ownerName,
        // ไม่รวม record_datetime
      };

  factory AddHistoryRec.fromJson(Map<String, dynamic> json) {
    return AddHistoryRec(
      header: json['header'],
      symptoms: json['Symptoms'],
      diagnose: json['Diagnose'],
      remark: json['Remark'],
      pets_id: json['pets_id'],
      ownerName: json['owner_name'],
    );
  }
}

