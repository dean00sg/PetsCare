import 'package:flutter/material.dart';

//Input Decoration สำหรับ TextField
final InputDecoration inputDecorationStyle = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
);

//Title
final TextStyle titleTextStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: Colors.brown[900],
);

//Container หลัก
final BoxDecoration containerBoxDecoration = BoxDecoration(
  color: const Color(0xFFF2B8B5),
  borderRadius: BorderRadius.circular(10),
);

//Container ประวัติสัตว์เลี้ยง
final BoxDecoration containerHistoryBoxDecoration = BoxDecoration(
  color: const Color(0xFF41A785),
  borderRadius: BorderRadius.circular(10),
);

//โปรไฟล์ Container
final BoxDecoration profileContainerBoxDecoration = BoxDecoration(
  color: const Color(0xFF266FCA),
  borderRadius: BorderRadius.circular(10),
);

//SnackBar สำหรับการแจ้งเตือน
const snackBarStyle = SnackBar(
  content: Text('Vaccination added successfully'),
);

//ElevatedButton
final ButtonStyle submitButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.cyan[400],
  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);
