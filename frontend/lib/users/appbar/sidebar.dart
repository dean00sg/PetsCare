import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Feed'),
            onTap: () {
              Navigator.pushNamed(context, '/feed');
            },
          ),
          ListTile(
            title: const Text('PETS'),
            onTap: () {
              Navigator.pushNamed(context, '/createpetsmain');
            },
          ),
          ListTile(
            title: const Text('My Pets'),
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
    );
  }
}
