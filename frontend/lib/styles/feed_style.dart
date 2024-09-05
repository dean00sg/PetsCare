import 'package:flutter/material.dart';

const TextStyle headerTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.brown,
);

const BoxDecoration containerDecoration = BoxDecoration(
  color: Colors.brown,
  borderRadius: BorderRadius.all(Radius.circular(16.0)),
  boxShadow: [
    BoxShadow(
      color: Colors.grey,
      blurRadius: 7,
      offset: Offset(0, 3), // ทำให้เกิดเงา
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
  height: 1.5,
   // ทำให้มีระยะห่างระหว่างบรรทัด
);
