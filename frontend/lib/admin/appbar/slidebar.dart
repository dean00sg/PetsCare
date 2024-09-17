import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // กำหนด padding เป็น 0
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 38, 111, 202),
            ),
            child: Text(
              'Admin Service',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('FeedPost'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/feedadmin'); // เปลี่ยนเส้นทางไปยังหน้า feedpost
            },
          ),
          ListTile(
            title: const Text('Check Info'),
            onTap: () {
              Navigator.pushNamed(context, '/checkinfo'); // เปลี่ยนเส้นทางไปยังหน้า checkinfo
            },
          ),
          // ListTile(
          //   title: const Text('Check Info'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => BlocProvider(
          //           create: (context) => AdminCheckInfoBloc(),
          //           child: const AdminCheckInfoScreen(),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            title: const Text('Add Notification'),
            onTap: () {
              Navigator.pushNamed(context,
                  '/notifications'); // เปลี่ยนเส้นทางไปยังหน้า addnotification
            },
          ),
        ],
      ),
    );
  }
}
