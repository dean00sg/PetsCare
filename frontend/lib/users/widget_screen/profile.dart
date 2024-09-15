import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.brown,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileBloc>().loadProfile();
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Profile Icon
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.brown,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Profile Texts
                  const Text(
                    'PROFILE',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // First Name
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'FirstName:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          state.profile.firstName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  
                  // Last Name
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'LastName:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          state.profile.lastName,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  
                  // Email
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Email:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          state.profile.email,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  
                  // Phone
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Phone:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          state.profile.phone,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Edit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        // Handle Edit button press
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.red),
                      ),
                      onPressed: () {
                        // Handle Logout button press
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoadFailure) {
            return const Center(child: Text('Failed to load profile'));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
