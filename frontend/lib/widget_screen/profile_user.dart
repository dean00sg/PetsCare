import 'package:flutter/material.dart';
import 'package:frontend/models/signup_model.dart'; // นำเข้า SignupModel

class ProfileUser extends StatelessWidget {
  final SignupModel userData; // รับข้อมูลจาก SignUpScreen

  const ProfileUser({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.brown[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // แสดงชื่อ
            Row(
              children: [
                const Text(
                  'First Name: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData.firstName,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // แสดงนามสกุล
            Row(
              children: [
                const Text(
                  'Last Name: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData.lastName,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // แสดงอีเมล
            Row(
              children: [
                const Text(
                  'Email: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData.email,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // แสดงหมายเลขโทรศัพท์
            Row(
              children: [
                const Text(
                  'Phone: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData.phone,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ปุ่มกลับไปหน้าหลัก
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // กลับไปหน้าก่อนหน้า
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.brown[400],
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
