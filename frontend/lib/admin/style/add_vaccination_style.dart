import 'package:flutter/material.dart';

// สไตล์ของ TextField input decoration
final InputDecoration inputDecorationStyle = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide.none,
  ),
);

// สไตล์ของ Title
final TextStyle titleTextStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  color: Colors.blueGrey[900],
);

// Box decoration สไตล์สำหรับ Container
final BoxDecoration containerBoxDecoration = BoxDecoration(
  color: const Color(0xFFF2B8B5),
  borderRadius: BorderRadius.circular(10),
);

final BoxDecoration containerHistoryBoxDecoration = BoxDecoration(
  color: const Color(0xFF90C8AC) ,
  borderRadius: BorderRadius.circular(10),
);

// สไตล์ของโปรไฟล์ Container
final BoxDecoration profileContainerBoxDecoration = BoxDecoration(
  color: const Color(0xFF266FCA),
  borderRadius: BorderRadius.circular(10),
);

// สไตล์ของ SnackBar สำหรับการแจ้งเตือน
const snackBarStyle = SnackBar(
  content: Text('Vaccination added successfully'),
);


// สไตล์ของ ElevatedButton
final ButtonStyle submitButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.cyan[400],
  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);


