import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/appbar/navbar.dart';
import 'package:frontend/admin/appbar/slidebar.dart';
import 'package:frontend/admin/bloc/notification_main.dart';
import 'package:frontend/admin/event/notification_main.dart';
import 'package:frontend/admin/style/notification_stye.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(), 
      drawer: const Sidebar(), 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50), // ปรับ padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4), // ปรับระยะห่างระหว่างหัวข้อและ GridView
            const Text(
              'Notification',
              style: TextStyle(
                fontSize: 40, // ปรับขนาดตัวอักษร
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // ปรับระยะห่างระหว่างหัวข้อและ GridView
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 30, // ระยะห่างระหว่างแถว
                crossAxisSpacing: 30, // ระยะห่างระหว่างคอลัมน์
                childAspectRatio: 1, // เปลี่ยนให้เป็นสี่เหลี่ยมจัตุรัส
                children: [
                  _buildNotificationCard(
                    context,
                    title: 'Add FeedPost',
                    icon: Icons.notifications,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).pushNamed('/addfeedpost');
                      BlocProvider.of<NotificationBloc>(context).add(AddNotificationEvent());
                    },
                  ),
                  _buildNotificationCard(
                    context,
                    title: 'Add News Feed Advice',
                    icon: Icons.article,
                    color: Colors.teal,
                    onTap: () {
                      BlocProvider.of<NotificationBloc>(context).add(AddNewsFeedAdviceEvent());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context,
      {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: notificationCardDecoration.copyWith(color: color), // ใช้ decoration จาก style file
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 8), // ระยะห่างระหว่างไอคอนและข้อความ
            Text(
              title,
              style: notificationCardTextStyle, // ใช้ text style จาก style file
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
