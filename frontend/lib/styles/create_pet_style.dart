import 'package:flutter/material.dart';

// สไตล์สำหรับ Container
final BoxDecoration containerDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 122, 83, 65),
  borderRadius: BorderRadius.circular(25),
);

// สไตล์ปุ่มบันทึก (Save)
final ButtonStyle saveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.amber,
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
);

// สไตล์ TextField
InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
  );
}
