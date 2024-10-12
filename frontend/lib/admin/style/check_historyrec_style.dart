import 'package:flutter/material.dart';

//container หลัก
const primaryColor = Color.fromARGB(255, 38, 111, 202);
const secondaryColor = Color(0xFF41A785);
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

//ข้อมูลเจ้าของสัตว์เลี้ยง
const ownerNameTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

//Pet Name
const petNameTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
  fontWeight: FontWeight.bold,
);

//ตัวอักษร Date และ Note by
const dateContainerTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white,
);

//Header, Symptoms, Diagnose
const regularTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

//หัวข้อฟอร์ม
const boldTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: Colors.black,
);

//ทั่วไป
final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.transparent,
  shadowColor: Colors.transparent,
  padding: EdgeInsets.zero,
);

//container ข้อมูลวัคซีน
var vaccineInfoBoxDecoration = BoxDecoration(
  color: const Color(0xFF90C8AC),
  borderRadius: BorderRadius.circular(8.0),
);

//container Date
const dateBoxDecoration = BoxDecoration(
  color: secondaryColor
);

//container Note
const noteBoxDecoration = BoxDecoration(
  color: Color.fromARGB(255, 100, 150, 230), 
);
