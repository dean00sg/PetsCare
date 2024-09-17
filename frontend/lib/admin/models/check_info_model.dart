import 'package:flutter/material.dart';

class CheckInfoItem {
  final String title;
  final IconData icon;
  final Color color;

  CheckInfoItem({
    required this.title,
    required this.icon,
    required this.color,
  });
}

List<CheckInfoItem> checkInfoItems = [
  CheckInfoItem(
    title: 'Check all user',
    icon: Icons.group,
    color: Colors.lightBlue,
  ),
  CheckInfoItem(
    title: 'Check all user by name',
    icon: Icons.person,
    color: Colors.cyan,
  ),
  CheckInfoItem(
    title: 'Check owner of  pets',
    icon: Icons.pets,
    color: Colors.lightBlueAccent,
  ),
  CheckInfoItem(
    title: 'Check vaccine of pets',
    icon: Icons.vaccines,
    color: Colors.teal.shade300,
  ),
];
