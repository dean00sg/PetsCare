import 'package:flutter/material.dart';

//profile container
final profileContainerDecoration = BoxDecoration(
  color: const Color.fromARGB(255, 38, 111, 202), 
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ],
);

//profile title
const titleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  letterSpacing: 1.5,
);

final containerDecoration = BoxDecoration(
  color: Colors.white.withOpacity(0.3),
  borderRadius: BorderRadius.circular(10),
);

//profile details
const profileDetailTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);


//profile data container
const containerPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 8);

//edit button
final editButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.amber,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
);

//logout button
final logoutButtonStyle = OutlinedButton.styleFrom(
  backgroundColor: Colors.red,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
);

//Avatar decoration
final profileAvatarDecoration = CircleAvatar(
  radius: 70,
  backgroundColor: Colors.white,
  child: Icon(
    Icons.person,
    size: 80,
    color: Colors.blue[800],
  ),
);
