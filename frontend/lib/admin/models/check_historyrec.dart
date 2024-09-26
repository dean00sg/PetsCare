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
