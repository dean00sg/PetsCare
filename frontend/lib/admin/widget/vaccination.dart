import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/vaccination.dart';
import 'package:frontend/admin/event/vaccination.dart';
import 'package:frontend/admin/state/vaccination.dart';

class PetVacProfilesScreen extends StatefulWidget {
  const PetVacProfilesScreen({super.key});

  @override
  _PetVacProfilesScreenState createState() => _PetVacProfilesScreenState();
}

class _PetVacProfilesScreenState extends State<PetVacProfilesScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically fetch vaccination profiles when the screen is initialized
    context.read<PetVacBloc>().add(FetchPetVacProfiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Vaccination Profiles')),
      body: BlocBuilder<PetVacBloc, PetVacState>(builder: (context, state) {
        if (state is PetVacLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PetVacLoaded) {
          return ListView.builder(
            itemCount: state.profiles.length,
            itemBuilder: (context, index) {
              final profile = state.profiles[index];

              // Displaying detailed information from the vaccination profile
              return ListTile(
                title: Text(profile.vacName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dose: ${profile.dose}'),
                    Text('Pet Name: ${profile.petName}'),
                    Text('Owner: ${profile.ownerName}'),
                    Text('Vaccination Date: ${profile.startDateVac}'),
                    Text('Location: ${profile.location}'),
                    Text('Remarks: ${profile.remark}'),
                    Text('Note by: ${profile.note_by}'),
                  ],
                ),
                isThreeLine: true,
              );
            },
          );
        } else if (state is PetVacError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No vaccination profiles available.'));
      }),
    );
  }
}
