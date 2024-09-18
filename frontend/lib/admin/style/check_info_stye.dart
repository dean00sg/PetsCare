import 'package:flutter/material.dart';

final BoxDecoration infoCardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(16.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 5,
      blurRadius: 7,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ],
);

const TextStyle infoCardTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
);