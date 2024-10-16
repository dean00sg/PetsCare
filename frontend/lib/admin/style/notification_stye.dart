import 'package:flutter/material.dart';

final BoxDecoration notificationCardDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 3,
      blurRadius: 5,
      offset: const Offset(0, 2), 
    ),
  ],
);

const TextStyle notificationCardTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
);


