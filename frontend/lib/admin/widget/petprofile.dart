import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/petprofile.dart';
import 'package:frontend/admin/event/petprofile.dart';
import 'package:frontend/admin/models/petprofile.dart';
import 'package:frontend/admin/repositories/petprofile.dart';
import 'package:frontend/admin/state/petprofile.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetProfileBloc(PetProfileRepository())..add(FetchPetsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User with Pets'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PetProfileBloc, PetProfileState>(
            builder: (context, state) {
              if (state is PetLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PetLoadedState) {
                if (state.pets.isEmpty) {
                  return const Center(child: Text('No pets available.'));
                }

                // Group pets by owner
                final Map<String, List<PetProfileModel>> ownerPetsMap = {};
                for (var pet in state.pets) {
                  ownerPetsMap.putIfAbsent(pet.owner_name, () => []).add(pet);
                }

                return ListView(
                  children: ownerPetsMap.entries.map((entry) {
                    final ownerName = entry.key;
                    final pets = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(ownerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ...pets.map((pet) => Card(
                          color: Colors.amber.shade200,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image.asset(PetTypeImage.getImagePath(pet.type_pets)),
                                  ),
                                  title: Text('Name: ${pet.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Text('Type: ${pet.type_pets}'),
                                Text('Sex: ${pet.sex}'),
                                Text('Breed: ${pet.breed}'),
                                Text('Birthdate: ${pet.birth_date}'),
                                Text('Weight: ${pet.weight}kg'),
                              ],
                            ),
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                );
              } else if (state is PetErrorState) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: Text('No pets found.'));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<PetProfileBloc>().add(FetchPetsEvent());
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
