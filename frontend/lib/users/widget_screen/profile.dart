import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileBloc>().loadProfile();
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return Column(
              children: [
                Text('First Name: ${state.profile.firstName}'),
                Text('Last Name: ${state.profile.lastName}'),
                Text('Email: ${state.profile.email}'),
                Text('Phone: ${state.profile.phone}'),
              ],
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