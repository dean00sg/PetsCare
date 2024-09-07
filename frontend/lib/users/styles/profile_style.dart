import 'package:flutter/material.dart';

// สไตล์สำหรับข้อความหัวข้อ (ชื่อผู้ใช้)
const TextStyle nameTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

// สไตล์สำหรับข้อความรอง (เช่น Email และ Phone)
const TextStyle infoTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

// สไตล์สำหรับ Container ที่คลุม Text
BoxDecoration containerDecoration = BoxDecoration(
  color: Colors.brown, // สีน้ำตาลสำหรับพื้นหลังของ Container
  borderRadius: BorderRadius.circular(10),
);

// สไตล์สำหรับปุ่ม Edit Profile
ButtonStyle editButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.brown[200], // สีพื้นหลังของปุ่ม
);


// สไตล์สำหรับขนาดของ CircleAvatar
double avatarRadius = 70;

final ButtonStyle signoutButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
);