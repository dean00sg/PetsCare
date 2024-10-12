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

  static final boxDecoration = BoxDecoration(
    color: Colors.blue[100],
    borderRadius: BorderRadius.circular(10),
    boxShadow: const [
      BoxShadow(
        color: Color(0xFFBBDEFB),
        spreadRadius: 3,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  );

  //Title
  static const healthAdviceTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  //ข้อความหัวข้อ
  static const headerTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  //ข้อมูลอายุและน้ำหนัก
  static const ageAndWeightTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  //Advice Section
  static const adviceTextStyleBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const adviceTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
}
