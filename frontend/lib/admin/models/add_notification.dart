import 'package:intl/intl.dart';

class AddNotificationUserModel {
  final int notiId;
  final String header;
  final String toUser;
  final String userName;
  final DateTime recordDatetime;
  final DateTime startNoti;
  final DateTime endNoti;
  final String file;
  final String detail;
  final String createBy;
  final String createname;

  AddNotificationUserModel({
    required this.notiId,
    required this.header,
    required this.toUser,
    required this.userName,
    required this.recordDatetime,
    required this.startNoti,
    required this.endNoti,
    required this.file,
    required this.detail,
    required this.createBy,
    required this.createname,
  });

  factory AddNotificationUserModel.fromJson(Map<String, dynamic> json) {
    return AddNotificationUserModel(
      notiId: json['noti_id'],
      header: json['header'],
      toUser: json['to_user'],
      userName: json['user_name'],
      recordDatetime: DateTime.parse(json['record_datetime']).toLocal(),
      startNoti: DateTime.parse(json['start_noti']).toLocal(),
      endNoti: DateTime.parse(json['end_noti']).toLocal(),
      file: json['file'],
      detail: json['detail'],
      createBy: json['create_by'],
      createname: json['create_name'],
    );
  }

  String getFormattedStartNoti() {
    return DateFormat('yyyy-MM-dd HH:mm').format(startNoti);
  }

  String getFormattedEndNoti() {
    return DateFormat('yyyy-MM-dd HH:mm').format(endNoti);
  }
}
