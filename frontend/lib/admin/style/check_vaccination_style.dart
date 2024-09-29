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

//container โปรไฟล์สัตว์เลี้ยง
const profileNameTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

//ช่องค้นหา
final searchBarDecoration = BoxDecoration(
  color: primaryColor,
  borderRadius: BorderRadius.circular(8.0),
);

//ขนาดของปุ่ม
const buttonTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

//ปุ่ม
final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.transparent,
  shadowColor: Colors.transparent,
  padding: EdgeInsets.zero,
);

//ข้อมูลโปรไฟล์เจ้าของสัตว์เลี้ยง
final profileContainerDecoration = BoxDecoration(
  color: primaryColor,
  borderRadius: BorderRadius.circular(8.0),
);

//ข้อมูลวัคซีน
final vaccineContainerDecoration = BoxDecoration(
  color: backgroundColor,
  borderRadius: BorderRadius.circular(8.0),
);

//Date 
final dateContainerDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 239, 30, 114),
  borderRadius: BorderRadius.circular(5),
);

//Note by
final noteByContainerDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 100, 150, 230), 
  borderRadius: BorderRadius.circular(5),
);

//ข้อความ Note by
const noteByTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white,
);

//ข้อมูลภายในฟอร์ม
const formTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

//หัวข้อข้อมูลภายในฟอร์ม
const boldFormTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
