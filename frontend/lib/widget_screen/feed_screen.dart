import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('WELCOME TO PET CARE', style: TextStyle(fontSize: 16)),
        centerTitle: true,
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
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown[400],
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Handle tap
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Handle tap
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Image.asset(
            'lib/images/cat1.png', // Replace with the correct image path
            height: 200, // Adjust height as needed
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          const Text(
            'อ่านบทความสุขภาพสัตว์เลี้ยงของคุณได้ที่นี่!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'คุณสามารถค้นหาข้อมูลที่เป็นประโยชน์เกี่ยวกับสุขภาพและการดูแลสัตว์เลี้ยงของคุณได้ที่นี่ การรับข้อมูลที่ถูกต้องจะช่วยให้คุณดูแลสัตว์เลี้ยงของคุณให้มีสุขภาพดีและมีความสุข.',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'lib/images/cat2.png', // Replace with the correct image path
            height: 200, // Adjust height as needed
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          const Text(
            'บทความอื่นๆ:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Additional articles or items can be added here
        ],
      ),
    );
  }
}
