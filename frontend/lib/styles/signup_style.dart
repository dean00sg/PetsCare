import 'package:flutter/material.dart';

// สีพื้นหลังของ Container
final BoxDecoration containerDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 122, 83, 65),
  borderRadius: BorderRadius.circular(25),
);

// สไตล์ข้อความหัวเรื่อง SIGN UP
const TextStyle signUpTitleStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// สไตล์ข้อความลิงก์ Sign In
const TextStyle signInLinkStyle = TextStyle(
  fontSize: 16,
  color: Colors.lightBlue,
);

// สไตล์ข้อความทั่วไป (Already member?)
const TextStyle generalTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);

// สไตล์ปุ่ม Sign Up
final ButtonStyle signUpButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.amber,
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
);

// สไตล์ของ TextField
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
