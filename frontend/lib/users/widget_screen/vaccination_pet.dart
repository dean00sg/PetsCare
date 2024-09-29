import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/users/bloc/vaccination_pet.dart'; 
import 'package:frontend/users/models/vaccination_pet.dart';
import 'package:frontend/users/state/vaccination_pet.dart';
import 'package:frontend/users/event/vaccination_pet.dart';
import 'package:frontend/users/styles/petprofile_style.dart';

class VaccinePetsScreen extends StatelessWidget {
  const VaccinePetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final petsId = arguments['petsId'] as int; 
    final petname = arguments['name'] as String; 
    final imagePath = arguments['image'] as String;

    context.read<PetVacUserBloc>().add(LoadPetVacUserProfile(petsId.toString())); 

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: PetProfileStyles.appBarBackgroundColor,
        centerTitle: true,
        toolbarHeight: 70,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 8),
            Text('Vaccine for Pet $petname', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
      body: BlocBuilder<PetVacUserBloc, PetVacUserState>(builder: (context, state) {
        if (state is PetVacUserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PetVacUserError) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is PetVacUserLoaded) {
          final vaccine = state.vacUserProfile;
          return _buildVaccineDetails(vaccine);
        } else {
          return const Center(child: Text('No vaccine data available'));
        }
      }),
    );
  }

  Widget _buildVaccineDetails(PetVacUserProfile vaccine) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vaccine Name: ${vaccine.vacName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Dose: ${vaccine.dose}'),
            Text('Start Date: ${vaccine.startDateVac}'),
            Text('Location: ${vaccine.location}'),
            const SizedBox(height: 16),
            Text('Status: ${vaccine.status}'),
            Text('Vaccine ID: ${vaccine.vacId}'),
            const SizedBox(height: 16),
            Text('Pet ID: ${vaccine.petsId}'),
            Text('Pet Name: ${vaccine.petName}'),
            Text('Owner Name: ${vaccine.ownerName}'),
            const SizedBox(height: 16),
            Text('Remark: ${vaccine.remark}'),
            Text('Note By: ${vaccine.noteBy}'),
          ],
        ),
      ),
    );
  }
}
