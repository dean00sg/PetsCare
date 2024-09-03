import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Pet Care'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Handle profile icon press
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Add a Drawer if you need one
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Image.asset('assets/cat.png'), // Replace with actual images
                const Text('ข่าวแมววัยใสใหม่ล่าสุด', style: TextStyle(fontSize: 18)),
                const Text('ทาสแมวมือใหม่ต้องรู้...', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          // More content here
        ],
      ),
    );
  }
}
