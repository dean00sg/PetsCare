import 'package:flutter/material.dart';

const TextStyle headerTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Color.fromARGB(255, 122, 83, 65),
);

const BoxDecoration containerDecoration = BoxDecoration(
  color: Color.fromARGB(255, 122, 83, 65),
  borderRadius: BorderRadius.all(Radius.circular(16.0)),
  boxShadow: [
    BoxShadow(
      color: Color.fromARGB(255, 122, 83, 65),
      blurRadius: 7,
      offset: Offset(0, 3), // Shadow offset
    ),
  ],
);

const TextStyle contentTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
);

const TextStyle subContentTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white,
  height: 1.5,  // Adjust line height
);
