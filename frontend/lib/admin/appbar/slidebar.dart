import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 38, 111, 202),
              ),
              child: Text(
                'ADMIN SERVICE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // ใช้ Container ครอบ ListTile แต่ละอัน
            const SizedBox(height: 25),
            if (currentRoute != '/feedadmin') 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 111, 202),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ], 
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Home', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/feedadmin');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            if (currentRoute != '/checkinfo') 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 111, 202),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ], 
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Check Info', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/checkinfo');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            if (currentRoute != '/notifications') 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 111, 202),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ], 
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Add Notifications', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            if (currentRoute != '/healthrecordmain') 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 38, 111, 202),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ], 
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Add Health Record', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/healthrecordmain');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            if (currentRoute != '/vaccinationmain') 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE09C99),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ], 
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Vaccination', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/vaccinationmain');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            if (currentRoute != '/historyrecmain') 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 9, 154, 132),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ], 
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Histry Record', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/historyrecmain');
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
}


