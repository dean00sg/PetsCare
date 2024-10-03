import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/appbar/navbar.dart';
import 'package:frontend/admin/appbar/slidebar.dart';
import 'package:frontend/admin/bloc/vaccination_main.dart';

class VaccinationMainWidget extends StatelessWidget {
  const VaccinationMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VaccinationMainBloc(),
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
                'Vaccination',
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
                    _buildVaccinationMainCard(
                      context,
                      title: 'Add Vaccine Pets',
                      icon: Icons.vaccines,
                      color: const Color(0xFF92B8E0),
                      onTap: () {
                        Navigator.of(context).pushNamed('/addvaccination');
                      },
                    ),
                    _buildVaccinationMainCard(
                      context,
                      title: 'Check Vaccination',
                      icon: Icons.search,
                      color: const Color(0xFFE09492),
                      onTap: () {
                        Navigator.of(context).pushNamed('/checkvaccination');
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

  Widget _buildVaccinationMainCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius:
              BorderRadius.circular(10), // Added border radius for better UI
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
