import 'package:flutter/material.dart';

// Styles for Containers and Cards
class AppStyles {
  static BoxDecoration userContainerDecoration = BoxDecoration(
    color: const Color.fromARGB(255, 38, 111, 202), 
    borderRadius: BorderRadius.circular(10.0), 
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        offset: const Offset(0, 4),
        blurRadius: 8,
      ),
    ],
  );

  static BoxDecoration petCardDecoration = BoxDecoration(
    color: Colors.amber[300], 
    borderRadius: BorderRadius.circular(8.0),
  );

  static TextStyle userNameTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 24,
  );

  static BoxDecoration petInfoBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4.0), 
  );

  static EdgeInsetsGeometry petInfoPadding = const EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 4.0,
  ); // ระยะห่างด้านในของข้อมูล

  static EdgeInsetsGeometry petInfoMargin = const EdgeInsets.symmetric(
    vertical: 4.0,
  ); // ระยะห่างระหว่างบรรทัด

  static TextStyle petLabelTextStyle =TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey[700],
    fontSize: 16,
  );

  static TextStyle petValueTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.grey[700],
    fontSize: 16,
  );
}
