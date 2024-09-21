import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.brown,
      iconTheme: const IconThemeData(size: 32, color: Colors.white),
      title: const Text(
        'PET CARE',
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        // Notification Icon
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, size: 32, color: Colors.white), 
              onPressed: () {
                // Navigate to notifications page
                Navigator.pushNamed(context, '/notificationUser');
              },
            ),
            Positioned(
              right: 11,
              top: 11,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: const Text(
                  '1', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        // Account Icon
        IconButton(
          icon: const Icon(Icons.account_circle, size: 32, color: Colors.white), 
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
      toolbarHeight: 70, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
