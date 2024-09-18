import 'package:flutter/material.dart';

// สไตล์ของ Container หลัก
final BoxDecoration containerDecoration = BoxDecoration(
  color: Colors.brown, // สีน้ำตาลตามรูป
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ],
);

// สไตล์ของ TextField
InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
  );
}

// สไตล์ของปุ่ม Save
final ButtonStyle saveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.amber,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 80),
);

// สไตล์ของข้อความ "Profile"
const TextStyle profileTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
