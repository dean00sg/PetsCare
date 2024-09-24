import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/appbar/navbar.dart';
import 'package:frontend/admin/appbar/slidebar.dart';
import 'package:frontend/admin/bloc/healthrecord_main.dart';
import 'package:frontend/admin/style/notification_stye.dart';

class HealthrecordMainWidget extends StatelessWidget {
  const HealthrecordMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HealthrecordMainBloc(),
      child: Scaffold(
        appBar: const Navbar(),
        drawer: const Sidebar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Health Record',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  childAspectRatio: 1,
                  children: [
                    _buildHealthrecordMainCard(
                      context,
                      title: 'Add Health Record',
                      icon: Icons.note_add,
                      color: const Color.fromARGB(255, 9, 196, 159),
                      onTap: () {
                        Navigator.of(context).pushNamed('/addfeedpost');
                      },
                    ),
                    _buildHealthrecordMainCard(
                      context,
                      title: 'Check Health Record',
                      icon: Icons.search,
                      color: Colors.teal,
                      onTap: () {
                        Navigator.of(context).pushNamed('/checkhealthrec');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthrecordMainCard(BuildContext context,
      {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: notificationCardDecoration.copyWith(color: color),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: notificationCardTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
