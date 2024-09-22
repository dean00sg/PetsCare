import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/petprofile.dart';

import 'package:frontend/users/event/petprofile.dart';
import 'package:frontend/users/state/petprofile.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petName = ModalRoute.of(context)?.settings.arguments as String;

    context.read<PetProfileBloc>().add(LoadPetProfile(petName));

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Profile: $petName'),
      ),
      body: BlocBuilder<PetProfileBloc, PetProfileState>(
        builder: (context, state) {
          if (state is PetProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PetProfileError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is PetProfileLoaded) {
            final pet = state.petProfile;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${pet.name}', style: const TextStyle(fontSize: 22)),
                  Text('Type: ${pet.typePets}', style: const TextStyle(fontSize: 18)),
                  Text('Sex: ${pet.sex}', style: const TextStyle(fontSize: 18)),
                  Text('Breed: ${pet.breed}', style: const TextStyle(fontSize: 18)),
                  Text('Birth Date: ${pet.birthDate}', style: const TextStyle(fontSize: 18)),
                  Text('Weight: ${pet.weight} kg', style: const TextStyle(fontSize: 18)),
                  Text('Owner: ${pet.ownerName}', style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No pet data available'));
          }
        },
      ),
    );
  }
}
