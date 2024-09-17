import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 38, 111, 202),
      iconTheme: const IconThemeData(size: 32, color: Colors.white),
      title: const Text(
        'Admin',
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle, size: 32, color: Colors.white), 
          onPressed: () {
            Navigator.pushNamed(context, '/profileadmin');
          },
        ),
      ],
      toolbarHeight: 70, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}