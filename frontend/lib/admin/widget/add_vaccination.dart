import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/admin/bloc/add_vaccination.dart';
import 'package:frontend/admin/event/add_vaccination.dart';
import 'package:frontend/admin/models/vaccination.dart';
import 'package:frontend/admin/repositories/petprofileuser.dart';
import 'package:frontend/admin/state/add_vaccination.dart';
import 'package:frontend/admin/models/petprofileuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVaccinationScreen extends StatefulWidget {
  const AddVaccinationScreen({super.key});

  @override
  _AddVaccinationScreenState createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  DateTime? selectedDate;
  final locationController = TextEditingController();
  final remarkController = TextEditingController();
  final vacNameController = TextEditingController();
  final doseController = TextEditingController();

  // Pet and Owner dropdown states
  List<PetProfileUserModel> petProfiles = [];
  List<String> ownerNames = [];
  List<String> petNames = [];

  String? selectedOwner;
  String? selectedPet;
  String? username; // Variable to hold the logged-in username

  @override
  void initState() {
    super.initState();
    _loadPetProfiles();
    _loadUsername(); // Load username when initializing the screen
  }

  Future<void> _loadPetProfiles() async {
    PetProfileUserRepository repository = PetProfileUserRepository();
    List<PetProfileUserModel> profiles = await repository.fetchPets();

    setState(() {
      petProfiles = profiles;
      ownerNames = profiles.map((pet) => pet.owner_name).toSet().toList(); // Get unique owner names
    });
  }

  Future<void> _loadUsername() async {
    // Load username from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? ''; // Assuming 'username' is stored here
    });
  }

  void _onOwnerChanged(String? newValue) {
    setState(() {
      selectedOwner = newValue;
      petNames = petProfiles
          .where((pet) => pet.owner_name == selectedOwner)
          .map((pet) => pet.name)
          .toList();
      selectedPet = null; // Reset selected pet when owner changes
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddVaccinationBloc, AddVaccinationState>(
      listener: (context, state) {
        if (state is AddVaccinationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vaccination added successfully')),
          );
          Navigator.pop(context); // Navigate back after success
        } else if (state is AddVaccinationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Vaccination'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Owner Name Dropdown
              DropdownButton<String>(
                value: selectedOwner,
                hint: const Text('Select Owner'),
                onChanged: _onOwnerChanged,
                items: ownerNames.map<DropdownMenuItem<String>>((String owner) {
                  return DropdownMenuItem<String>(
                    value: owner,
                    child: Text(owner),
                  );
                }).toList(),
              ),
              
              // Pet Name Dropdown
              DropdownButton<String>(
                value: selectedPet,
                hint: const Text('Select Pet'),
                onChanged: (newValue) {
                  setState(() {
                    selectedPet = newValue;
                  });
                },
                items: petNames.map<DropdownMenuItem<String>>((String pet) {
                  return DropdownMenuItem<String>(
                    value: pet,
                    child: Text(pet),
                  );
                }).toList(),
              ),
              
              TextField(
                controller: vacNameController,
                decoration: const InputDecoration(labelText: 'Vaccination Name'),
              ),
              TextField(
                controller: doseController,
                decoration: const InputDecoration(labelText: 'Dose'),
                keyboardType: TextInputType.number,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: selectedDate != null
                          ? "${selectedDate!.toLocal()}".split(' ')[0]
                          : 'Select Vaccination Date',
                    ),
                  ),
                ),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: remarkController,
                decoration: const InputDecoration(labelText: 'Remark'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedOwner != null && selectedPet != null && selectedDate != null && username != null) {
                    final profile = AddPetVacProfile(
                      dose: int.parse(doseController.text),
                      vacName: vacNameController.text,
                      startDateVac: selectedDate!,
                      location: locationController.text,
                      remark: remarkController.text,
                      petName: selectedPet!,
                      ownerName: selectedOwner!,
                      note_by: username!, // Use the logged-in username for note_by
                    );

                    // Dispatch the event to the bloc
                    context.read<AddVaccinationBloc>().add(SubmitVaccinationForm(profile));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill out all fields')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}