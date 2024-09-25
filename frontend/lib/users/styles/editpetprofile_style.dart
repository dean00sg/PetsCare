import 'package:flutter/material.dart';

final BoxDecoration profileContainerDecoration = BoxDecoration(
  color: Colors.brown,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ],
);



final InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(10),
  ),
);

const TextStyle profileTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

final saveButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.amber,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  textStyle: const TextStyle(
    fontSize: 18,
  ),
);

