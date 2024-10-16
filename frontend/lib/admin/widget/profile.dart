import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/style/profile.dart';
import 'package:frontend/admin/widget/editprofile.dart';
import 'package:frontend/users/bloc/profile_bloc.dart';
import 'package:frontend/users/repositories/profile_repository.dart';
import 'package:frontend/users/state/profile_state.dart';



class ProfileAdminScreen extends StatelessWidget {
  const ProfileAdminScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Profile', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 38, 111, 202), 
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileBloc>().loadProfile();
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return Center(
              child: Container(
                width: 350,
                height: 600,
                padding: const EdgeInsets.all(20.0),
                decoration: profileContainerDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Icon
                    profileAvatarDecoration,
                    const SizedBox(height: 20),

                    // Profile Title
                    const Text('PROFILE ADMIN', style: titleStyle),
                    const SizedBox(height: 20),

                    // First Name
                    Container(
                      padding: containerPadding,
                      decoration: containerDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('FirstName:', style: profileDetailTextStyle),
                          Text(state.profile.firstName, style: profileDetailTextStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Last Name
                    Container(
                      padding: containerPadding,
                      decoration: containerDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('LastName:', style: profileDetailTextStyle),
                          Text(state.profile.lastName, style: profileDetailTextStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email
                    Container(
                      padding: containerPadding,
                      decoration: containerDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('E-mail:', style: profileDetailTextStyle),
                          Text(state.profile.email, style: profileDetailTextStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Phone
                    Container(
                      padding: containerPadding,
                      decoration: containerDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Phone:', style: profileDetailTextStyle),
                          Text(state.profile.phone, style: profileDetailTextStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Edit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: editButtonStyle,
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfileAdminScreen(profile: state.profile),
                            ),
                          );
                          if (result == true) {
                            context.read<ProfileBloc>().loadProfile(); // Reload profile if updated
                          }
                        },
                        child: const Text('Edit', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: logoutButtonStyle,
                        onPressed: () async {
                          final profileRepository = ProfileRepository(apiUrl: 'https://pets-care.onrender.com');
                          await profileRepository.logout();

                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
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
