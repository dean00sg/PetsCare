import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/user.dart';
import 'package:frontend/admin/models/user.dart';
import 'package:frontend/admin/state/user.dart';

class CheckAllUsersScreen extends StatefulWidget {
  @override
  _CheckAllUsersScreenState createState() => _CheckAllUsersScreenState();
}

class _CheckAllUsersScreenState extends State<CheckAllUsersScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).loadUserPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); 
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Check all user', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 38, 111, 202),
        centerTitle: true,
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Check All User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserPetsLoaded) {
                    final List<UserProfilePets> profiles = state.profiles;

                    List<UserProfilePets> userPets = profiles
                        .where((user) => user.role == 'userpets')
                        .toList();

                    if (userPets.isEmpty) {
                      return const Center(child: Text('No users found'));
                    }

                    return ListView.builder(
                      itemCount: userPets.length,
                      itemBuilder: (context, index) {
                        final user = userPets[index];
                        return Card(
                          color: Colors.blue,
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Colors.white),
                            title: Text(
                              user.firstName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              user.email,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is UserLoadFailure) {
                    return const Center(child: Text('Failed to load users'));
                  }
                  return const Center(child: Text('Unexpected state'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
