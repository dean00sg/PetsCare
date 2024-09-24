import 'package:flutter/material.dart';

class PetProfileStyles {
  static const TextStyle petNameTextStyle = TextStyle(
    fontSize: 22,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle petInfoTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const Color appBarBackgroundColor = Colors.brown;

  static const Color containerBackgroundColor = Colors.brown;

  static const Icon editIcon = Icon(Icons.edit_square, color: Colors.white);

  static const double iconSize = 30.0;

  static BoxDecoration containerBoxDecoration = BoxDecoration(
    color: containerBackgroundColor,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: containerBackgroundColor.withOpacity(0.5),
        spreadRadius: 3,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
