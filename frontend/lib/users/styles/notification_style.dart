import 'package:flutter/material.dart';

class NotificationStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle headerStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );


  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 12,
    color: Colors.white70,
  );

  static const TextStyle detailStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

  static BoxDecoration deleteButtonDecoration = const BoxDecoration(
    color: Colors.brown,
    shape: BoxShape.circle,
  );
}
