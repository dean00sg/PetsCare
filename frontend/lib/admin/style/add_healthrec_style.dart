import 'package:flutter/material.dart';

//container หลัก
const primaryColor = Color.fromARGB(255, 38, 111, 202);
const secondaryColor = Color(0xFFED7777);
const backgroundColor = Colors.white;

//AppBar Title
const appBarTitleTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.white,
);

//Header
final headerTextStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: Colors.blueGrey[900],
);

//ชื่อเจ้าของโปรไฟล์
const profileNameTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

//ข้อมูลในฟอร์ม
const formLabelTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
);

//ปุ่มบันทึก
const buttonTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
);

//container ช่องกรอกฟอร์ม
final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.cyan[400],
  padding: const EdgeInsets.symmetric(vertical: 15),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

//container โปรไฟล์เจ้าของสัตว์เลี้ยง
final profileContainerDecoration = BoxDecoration(
  color: Colors.amber,
  borderRadius: BorderRadius.circular(10),
);


final formContainerDecoration = BoxDecoration(
  color: primaryColor,
  borderRadius: BorderRadius.circular(10),
);

//ช่องกรอกฟอร์ม
InputDecoration textFieldDecoration = InputDecoration(
  filled: true,
  fillColor: const Color(0xFFDDF3FF),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide.none,
  ),
);
