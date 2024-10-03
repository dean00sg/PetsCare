import 'package:equatable/equatable.dart';

class HistoryRecUserModel extends Equatable {
  final int hrId;
  final String header;
  final DateTime recordDateTime;
  final String symptoms;
  final String diagnose;
  final String remark;
  final int petsId;
  final String petName;
  final String ownerName;
  final String noteBy;
  final String noteName;

  const HistoryRecUserModel({
    required this.hrId,
    required this.header,
    required this.recordDateTime,
    required this.symptoms,
    required this.diagnose,
    required this.remark,
    required this.petsId,
    required this.petName,
    required this.ownerName,
    required this.noteBy,
    required this.noteName,
  });

  factory HistoryRecUserModel.fromJson(Map<String, dynamic> json) {
    return HistoryRecUserModel(
      hrId: json['hr_id'],
      header: json['header'],
      recordDateTime: DateTime.parse(json['record_datetime']),
      symptoms: json['Symptoms'],
      diagnose: json['Diagnose'],
      remark: json['Remark'],
      petsId: json['pets_id'],
      petName: json['pet_name'],
      ownerName: json['owner_name'],
      noteBy: json['note_by'],
      noteName: json['note_name'],
    );
  }

  @override
  List<Object?> get props => [
        hrId,
        header,
        recordDateTime,
        symptoms,
        diagnose,
        remark,
        petsId,
        petName,
        ownerName,
        noteBy,
        noteName,
      ];
}
