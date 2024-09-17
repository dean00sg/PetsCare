import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/appbar/navbar.dart';
import 'package:frontend/admin/bloc/check_info_bloc.dart';
import 'package:frontend/admin/event/check_info_event.dart';
import 'package:frontend/admin/appbar/sidebar.dart';
import 'package:frontend/admin/style/check_info_stye.dart'; 

class AdminCheckInfoScreen extends StatelessWidget {
  const AdminCheckInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(), 
      drawer: const Sidebar(), 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4), //ปรับระยะห่างระหว่างหัวข้อและ Tab Bar
            const Text(
              'Check Info',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),  //ปรับระยะห่างระหว่างหัวข้อและ GridView
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                childAspectRatio: 4 / 4,
                children: [
                  _buildInfoCard(context, 'check all user', Icons.group, Colors.blue),
                  _buildInfoCard(context, 'check all user by name', Icons.person_search, Colors.teal),
                  _buildInfoCard(context, 'check owner of pets', Icons.pets, Colors.cyan),
                  _buildInfoCard(context, 'check vaccine of pets', Icons.vaccines, Colors.teal[300]!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        if (title == 'check all user') {
          BlocProvider.of<AdminCheckInfoBloc>(context).add(CheckAllUsersEvent());
        } else if (title == 'check all user by name') {
          BlocProvider.of<AdminCheckInfoBloc>(context).add(CheckUsersByNameEvent());
        } else if (title == 'check owner of pets') {
          BlocProvider.of<AdminCheckInfoBloc>(context).add(CheckOwnersOfPetsEvent());
        } else if (title == 'check vaccine of pets') {
          BlocProvider.of<AdminCheckInfoBloc>(context).add(CheckVaccinesOfPetsEvent());
        }
      },
      child: Container(
        decoration: infoCardDecoration.copyWith(color: color), // Apply decoration from the style file
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: infoCardTextStyle, // Apply text style from the style file
            ),
          ],
        ),
      ),
    );
  }
}
