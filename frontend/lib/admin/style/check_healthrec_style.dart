import 'package:flutter/material.dart';

class HealthStyles {

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle healthTitleTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle healthInfoTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const Icon editIcon = Icon(Icons.edit_square, color: Colors.white);

  static const double iconSize = 35;

  static BoxDecoration containerBoxDecoration = BoxDecoration(
    color: const Color.fromARGB(255, 38, 111, 202),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 3,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  );


}