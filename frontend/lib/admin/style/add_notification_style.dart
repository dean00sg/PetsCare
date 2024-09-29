import 'package:flutter/material.dart';

//Container หลัก Notification
const Color primaryColor = Color.fromARGB(255, 38, 111, 202);
const Color secondaryColor = Colors.amber;

//TextStyle หัวข้อ
const TextStyle appBarTitleTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.white,
);

//TextStyle ข้อมูลในฟอร์ม
const TextStyle inputTextStyle = TextStyle(color: Colors.black);
const TextStyle headerTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
const TextStyle detailTextStyle = TextStyle(color: Colors.white);

//ปุ่ม ElevatedButton
final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.cyan[400],
  padding: const EdgeInsets.symmetric(vertical: 15),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

//TextField
InputDecoration inputDecoration = const InputDecoration(
  filled: true,
  fillColor: Color(0xFFDDF3FF),
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
