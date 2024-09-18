import 'package:flutter/material.dart';

// สไตล์ของ Container หลักที่ครอบทุกอย่าง
final BoxDecoration mainContainerDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 38, 111, 202),
  borderRadius: BorderRadius.circular(10),
);

// สไตล์ของ ElevatedButton
final ButtonStyle submitButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.cyan[400],
  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

// สไตล์ของ TextFormField
InputDecoration inputDecoration(String label) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.lightBlue[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );
}

