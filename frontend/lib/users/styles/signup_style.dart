import 'package:flutter/material.dart';

//Container main
final BoxDecoration containerDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 122, 83, 65),
  borderRadius: BorderRadius.circular(25),
);

//SIGN UP
const TextStyle signUpTitleStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

//Sign In
const TextStyle signInLinkStyle = TextStyle(
  fontSize: 16,
  color: Colors.lightBlue,
);

// สไตล์ข้อความทั่วไป (Already member?)
const TextStyle generalTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);

//ปุ่ม Sign Up
final ButtonStyle signUpButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.amber,
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
);

//TextField
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
