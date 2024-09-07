// lib/styles/login_style.dart

import 'package:flutter/material.dart';

// สไตล์ของชื่อหัวข้อ SIGN IN
const TextStyle signInTitleStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// สไตล์ของปุ่ม Sign In และ Sign Up
final ButtonStyle loginButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.amber,
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
);

// สไตล์ของ TextField สำหรับใส่ Username/Password
InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    filled: true,
    fillColor: const Color.fromARGB(255, 255, 255, 255),
    hintText: hintText,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide.none,
    ),
  );
}

// สไตล์ของ Container
final BoxDecoration containerDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 122, 83, 65),
  borderRadius: BorderRadius.circular(25),
);
